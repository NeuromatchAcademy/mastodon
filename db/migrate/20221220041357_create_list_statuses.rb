
class CreateListStatuses < ActiveRecord::Migration[6.1]

  def change
    create_table :list_statuses do |t|
      t.belongs_to :list, null: false, foreign_key: { on_delete: :cascade }
      t.belongs_to :status, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :list_statuses, [:status_id, :list_id], unique: true
    add_index :list_statuses, [:list_id, :status_id]

  end
end
