# frozen_string_literal: true
# == Schema Information
#
# Table name: list_statuses
#
#  id         :bigint(8)        not null, primary key
#  list_id    :bigint(8)        not null
#  status_id  :bigint(8)        not null
#

class ListStatus < ApplicationRecord
  belongs_to :list
  belongs_to :status

  validates :status_id, uniqueness: { scope: :list_id }

  private

end
