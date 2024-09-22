# frozen_string_literal: true

class FetchReplyWorker
  include Sidekiq::Worker
  include ExponentialBackoff
  include JsonLdHelper

  sidekiq_options queue: 'pull', retry: 3

  def perform(child_url, options = {})
    @all_replies = options.fetch('all_replies', nil)
    @current_account_id = options.delete('current_account_id')

    @status = FetchRemoteStatusService.new.call(child_url, **options.deep_symbolize_keys)

    recurse

    @status
  end

  private

  def recurse
    return unless @all_replies && @status

    ActivityPub::FetchRepliesWorker.perform_in(
      rand(1..30).seconds,
      @status.id,
      nil,
      {
        allow_synchronous_requests: true,
        all_replies: true,
        current_account_id: @current_account_id,
      }
    )
  end
end
