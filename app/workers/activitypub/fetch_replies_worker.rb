# frozen_string_literal: true

class ActivityPub::FetchRepliesWorker
  include Sidekiq::Worker
  include ExponentialBackoff

  sidekiq_options queue: 'pull', retry: 3

  def perform(parent_status_id, replies_uri = nil, options = {})
    @current_account_id = options.fetch(:current_account_id, nil)
    replies_uri = get_replies_uri(status) if replies_uri.nil?
    return if replies_uri.nil?

    ActivityPub::FetchRepliesService.new.call(Status.find(parent_status_id), replies_uri, **options.deep_symbolize_keys)
  rescue ActiveRecord::RecordNotFound
    true
  end

  private

  def get_replies_uri(status)
    current_account = @current_account_id.nil? ? nil : Account.find(id: @current_account_id)
    json_status = fetch_resource(status.uri, true, current_account)
    replies_uri = json_status['replies']
    Rails.logger.debug { "Could not find replies uri for status: #{status}" } if replies_uri.nil?
    replies_uri
  end
end
