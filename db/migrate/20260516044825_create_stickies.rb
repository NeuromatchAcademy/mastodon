# frozen_string_literal: true

class CreateStickies < ActiveRecord::Migration[8.0]
  def change
    create_table :stickies do |t|
      t.references :status, null: false, foreign_key: true

      t.timestamps
    end
  end
end
