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
  include Redisable

  belongs_to :status

  scope :stickied_statuses, lambda {
    Status.local
      .distributable_visibility
      .joins(:sticky)
      .reorder('stickies.created_at DESC')
  }

  after_create :clear_cache
  after_destroy :clear_cache

  # Cached set of sticky status IDs used to check for status stickiness without an extra query
  # There are only ever a small number of stickies and they change slowly.
  #
  # @return Set<Integer>
  def self.stickies
    Rails.cache.fetch('stickies', expires_in: 1.day) do
      Sticky.reorder('stickies.created_at DESC').pluck(:status_id).to_set
    end
  end

  private

  def clear_cache
    Rails.cache.delete('stickies')
  end
end
