# frozen_string_literal: true

class AddIndexReblogOfIdAndStatusToStatuses < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    add_index :statuses, [:reblog_of_id, :id], order: { reblog_of_id: 'DESC NULLS LAST', id: 'DESC' }, algorithm: :concurrently
  end
end
