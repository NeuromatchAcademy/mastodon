# frozen_string_literal: true

class AddSlugToStatus < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :slug, :string, null: true
  end
end
