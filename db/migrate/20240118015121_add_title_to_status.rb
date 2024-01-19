# frozen_string_literal: true

class AddTitleToStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :title, :string, null: true
  end
end
