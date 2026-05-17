# frozen_string_literal: true

# Mark a status as sticky! Show it at the top of home and local feeds.
#
# == Schema Information
#
# Table name: stickies
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status_id  :bigint(8)        not null
#
class Sticky < ApplicationRecord
  belongs_to :status

  scope :stickied_statuses, lambda {
    Status.local
      .distributable_visibility
      .joins(:sticky)
      .reorder('stickies.created_at DESC')
  }
end
