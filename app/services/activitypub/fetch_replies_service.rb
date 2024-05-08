# frozen_string_literal: true

class ActivityPub::FetchRepliesService < BaseService
  include JsonLdHelper

  # Limit of fetched replies used when not fetching all replies
  MAX_REPLIES_LOW = 5

  def call(parent_status, collection_or_uri, allow_synchronous_requests: true, request_id: nil, all_replies: false)
    # Whether we are getting replies from more than the originating server,
    # and don't limit ourselves to getting at most `MAX_REPLIES_LOW`
    @all_replies = all_replies

    @account = parent_status.account
    @allow_synchronous_requests = allow_synchronous_requests

    @items = collection_items(collection_or_uri)
    logger = Logger.new(STDOUT)
    logger.warn 'collection items'
    logger.warn @items
    return if @items.nil?

    FetchReplyWorker.push_bulk(filtered_replies) { |reply_uri| [reply_uri, { 'request_id' => request_id }] }

    @items
  end

  private

  def collection_items(collection_or_uri)
    logger = Logger.new(STDOUT)
    collection = fetch_collection(collection_or_uri)
    logger.warn 'first collection'
    logger.warn collection
    return unless collection.is_a?(Hash)

    collection = fetch_collection(collection['first']) if collection['first'].present?
    logger.warn 'second collection'
    logger.warn collection
    return unless collection.is_a?(Hash)

    # Need to do another "next" here. see https://neuromatch.social/users/jonny/statuses/112401738180959195/replies for example
    # then we are home free (stopping for tonight tho.)

    case collection['type']
    when 'Collection', 'CollectionPage'
      as_array(collection['items'])
    when 'OrderedCollection', 'OrderedCollectionPage'
      as_array(collection['orderedItems'])
    end
  end

  def fetch_collection(collection_or_uri)
    return collection_or_uri if collection_or_uri.is_a?(Hash)
    return unless @allow_synchronous_requests
    return if !@all_replies && non_matching_uri_hosts?(@account.uri, collection_or_uri)

    # NOTE: For backward compatibility reasons, Mastodon signs outgoing
    # queries incorrectly by default.
    #
    # While this is relevant for all URLs with query strings, this is
    # the only code path where this happens in practice.
    #
    # Therefore, retry with correct signatures if this fails.
    begin
      fetch_resource_without_id_validation(collection_or_uri, nil, true)
    rescue Mastodon::UnexpectedResponseError => e
      raise unless e.response && e.response.code == 401 && Addressable::URI.parse(collection_or_uri).query.present?

      fetch_resource_without_id_validation(collection_or_uri, nil, true, request_options: { with_query_string: true })
    end
  end

  def filtered_replies
    if @all_replies
      @items.map { |item| value_or_id(item) }
    else
      # Only fetch replies to the same server as the original status to avoid
      # amplification attacks.

      # Also limit to 5 fetched replies to limit potential for DoS.
      @items.map { |item| value_or_id(item) }.reject { |uri| non_matching_uri_hosts?(@account.uri, uri) }.take(MAX_REPLIES_LOW)
    end
  end
end
