# frozen_string_literal: true

class BootstrapTimelineService < BaseService
  def call(source_account)
    @source_account = source_account

    autofollow_inviter!
    notify_staff!
    autofollow!
  end

  private

  def autofollow_inviter!
    return unless @source_account&.user&.invite&.autofollow?

    FollowService.new.call(@source_account, @source_account.user.invite.user.account)
  end

  def autofollow!
    return if ENV['AUTOFOLLOW'].blank?

    ENV['AUTOFOLLOW'].to_s.split(',').each do |account|
      begin
        to_follow = Account.find_local!(account.strip)
        FollowService.new.call(@source_account, to_follow)
      rescue ActiveRecord::RecordNotFound
        Rails.logger.warn("Could not find account #{account} to autofollow")
      end
    end
  end

  def notify_staff!
    User.those_who_can(:manage_users).includes(:account).find_each do |user|
      LocalNotificationWorker.perform_async(user.account_id, @source_account.id, 'Account', 'admin.sign_up')
    end
  end
end
