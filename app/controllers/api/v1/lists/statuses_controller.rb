

class Api::V1::Lists::StatusesController < Api::BaseController
  before_action -> { doorkeeper_authorize! :read, :'read:lists' }, only: [:show]
  before_action -> { doorkeeper_authorize! :write, :'write:lists' }, except: [:show]


  before_action :require_user!
  before_action :set_list


  after_action :insert_pagination_headers, only: :show

  def create
    ApplicationRecord.transaction do
      list_accounts.each do |account|
        @list.accounts << account
      end
    end

    render_empty
  end

  private

  def set_list
    @list = List.where(account: current_account).find(params[:list_id])
  end

  def list_statuses
    Status.find(status_ids)
  end


  def load_accounts
    if unlimited?
      @list.accounts.without_suspended.includes(:account_stat).all
    else
      @list.accounts.without_suspended.includes(:account_stat).paginate_by_max_id(limit_param(DEFAULT_ACCOUNTS_LIMIT), params[:max_id], params[:since_id])
    end
  end

  def list_accounts
    Status.find(status_ids)
  end

  def status_ids
    Array(resource_params[:status_ids])
  end

  def resource_params
    params.permit(status_ids: [])
  end


end
