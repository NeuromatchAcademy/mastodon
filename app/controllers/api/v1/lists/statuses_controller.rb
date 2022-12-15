

class Api::V1::Lists::StatusesController < Api::BaseController
  before_action -> { doorkeeper_authorize! :read, :'read:lists' }, only: [:show]
  before_action -> { doorkeeper_authorize! :write, :'write:lists' }, except: [:show]

  before_action :require_user!
  before_action :set_list

  after_action :insert_pagination_headers, only: :show

  def show
    @statuses = load_statuses
    render json: @statuses, each_serializer: REST::StatusSerializer
  end

  def create
    ApplicationRecord.transaction do
      list_statuses.each do |status|
        @list.statuses << status
      end
    end

    render_empty
  end

  def destroy
    ListStatus.where(list: @list, account_id: status_ids).destroy_all
    render_empty
  end

  private

  def set_list
    @list = List.where(account: current_account).find(params[:list_id])
  end

  def list_statuses
    Status.find(status_ids)
  end


  def load_statuses
    if unlimited?
      @list.statuses.all
    else
      @list.statuses.paginate_by_max_id(limit_param(DEFAULT_ACCOUNTS_LIMIT), params[:max_id], params[:since_id])
    end
  end

  def status_ids
    Array(resource_params[:status_ids])
  end

  def resource_params
    params.permit(status_ids: [])
  end

  def unlimited?
    true
  end
end
