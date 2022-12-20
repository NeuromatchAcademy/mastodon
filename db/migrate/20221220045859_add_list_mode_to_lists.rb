require Rails.root.join('lib', 'mastodon', 'migration_helpers')

class AddListModeToLists < ActiveRecord::Migration[6.1]
  include Mastodon::MigrationHelpers

  disable_ddl_transaction!

  def up
    safety_assured do
      add_column_with_default(
        :lists,
        :list_mode,
        :integer,
        allow_null: false,
        default: 0
      )
    end
  end

  def down
    remove_column :lists, :list_mode
  end
end
