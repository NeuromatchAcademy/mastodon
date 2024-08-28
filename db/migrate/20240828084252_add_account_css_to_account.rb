# frozen_string_literal: true

class AddAccountCssToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :account_css, :text, null: true
  end
end
