# frozen_string_literal: true

class Api::V1::Statuses::StickiesController < Api::V1::Statuses::BaseController
  before_action -> { doorkeeper_authorize! :write, :'write:statuses' }
  before_action :require_user!
  before_action :require_manage_users!

  def create
    Sticky.find_or_create_by!(status: @status)
    render json: @status, serializer: REST::StatusSerializer
  end

  def destroy
    @status.sticky&.destroy
    render json: @status.reload, serializer: REST::StatusSerializer
  end

  private

  def require_manage_users!
    forbidden unless current_user&.role&.can?(:manage_users)
  end
end
