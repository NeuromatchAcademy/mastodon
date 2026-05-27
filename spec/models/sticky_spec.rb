# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sticky do
  describe 'Validations' do
    it 'requires a status' do
      sticky = described_class.new
      expect(sticky).to_not be_valid
      expect(sticky.errors[:status]).to be_present
    end
  end

  describe 'Association' do
    it 'is destroyed when the parent status is destroyed' do
      status = Fabricate(:status)
      described_class.create!(status: status)

      expect { status.destroy }.to change(described_class, :count).by(-1)
    end
  end

  describe '.stickied_statuses' do
    let!(:older_sticky_status) { Fabricate(:status, visibility: :public) }
    let!(:newer_sticky_status) { Fabricate(:status, visibility: :public) }

    before do
      described_class.create!(status: older_sticky_status, created_at: 2.hours.ago)
      described_class.create!(status: newer_sticky_status, created_at: 1.hour.ago)
    end

    it 'returns sticky statuses ordered by sticky creation desc' do
      expect(described_class.stickied_statuses.to_a).to eq [newer_sticky_status, older_sticky_status]
    end

    it 'excludes private and direct statuses' do
      private_status = Fabricate(:status, visibility: :private)
      direct_status = Fabricate(:status, visibility: :direct)
      described_class.create!(status: private_status)
      described_class.create!(status: direct_status)

      ids = described_class.stickied_statuses.pluck(:id)
      expect(ids).to_not include(private_status.id, direct_status.id)
    end
  end
end
