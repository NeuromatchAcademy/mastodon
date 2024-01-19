# frozen_string_literal: true

#
# A subclass to be able to retrieve statuses by /:acct/:slug

class Api::V1::Accounts::SlugsController < Api::V1::StatusesController
  before_action :set_account
  before_action :set_status

  def show
    cache_if_unauthenticated!
    @status = cache_collection([@status], Status).first
    render json: @status, serializer: REST::StatusSerializer
  end

  def set_status
    @status = @account.statuses.find_by!(slug: params[:id])

    # begin

    # rescue
    # FIXME: This is not great, beause slugs are only guaranteed unique per user.
    # so we need to modify whatever is calling this with the slug rather than the ID
    # somewhere in the react
    # @status = Status.find_by!(slug: params[:id])
    # end
    authorize @status, :show?
  rescue Mastodon::NotPermittedError
    not_found
  end

  def set_account
    @account = Account.find_local!(params[:account_id])
  end
end
