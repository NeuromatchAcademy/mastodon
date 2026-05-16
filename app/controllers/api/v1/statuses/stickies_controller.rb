# frozen_string_literal: true

class Api::V1::Statuses::StickiesController < Api::V1::Statuses::BaseController
  include Authorization

  before_action :set_status
  # before_action -> { authorize_if_got_token! :'admin:write', :'admin:write:accounts', except: [:index, :show] }

  # before_action -> { authorize_if_got_token! :'admin:read', :'admin:read:reports' }, only: [:index, :show]
  # before_action -> { authorize_if_got_token! :'admin:write', :'admin:write:reports' }, except: [:show]

  after_action :verify_authorized
  # skip_before_action :set_status, only: [:destroy]

  def show
    render json: @status, serializer: REST::StatusSerializer
  end

  def create
    Sticky.create(status_id: @status.id)
    render json: @status, serializer: REST::StatusSerializer
  end

  def destroy
    @status.sticky.destroy
    render json: @status, serializer: REST::StatusSerializer
  rescue ActiveRecord::RecordNotFound, Mastodon::NotPermittedError
    not_found
  end
end
