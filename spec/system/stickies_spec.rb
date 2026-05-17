# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sticky posts', :inline_jobs, :js do
  include ProfileStories

  let(:email)               { 'test@example.com' }
  let(:password)            { 'password' }
  let(:confirmed_at)        { Time.zone.now }
  let(:finished_onboarding) { true }
  let!(:other_account)      { Fabricate(:account, username: 'alice') }
  let!(:target_status)      { Fabricate(:status, account: other_account, text: 'Hello from Alice', visibility: :public) }

  before do
    Setting.local_live_feed_access = 'public'
    as_a_logged_in_user
    bob.update!(role: UserRole.find_by!(name: 'Moderator'))
    page.refresh
  end

  it 'toggles stickiness from off to on' do
    ignore_js_error(/Failed to load resource/)

    visit '/public/local'

    expect(page).to have_css('.status', text: 'Hello from Alice')

    within(first('.status')) do
      find('button[title="More"]').click_button
    end

    within('.dropdown-menu') do
      expect(page).to have_text('Make this post globally sticky')
      click_on 'Make this post globally sticky'
    end

    within(first('.status')) do
      find('button[title="More"]').click_button
    end

    within('.dropdown-menu') do
      expect(page).to have_text('Unsticky this post')
    end

    expect(Sticky.exists?(status_id: target_status.id)).to be true
  end

  it 'toggles stickiness from on to off' do
    Sticky.create!(status: target_status)

    ignore_js_error(/Failed to load resource/)

    visit '/public/local'

    within(first('.status')) do
      find('button[title="More"]').click_button
    end

    within('.dropdown-menu') do
      click_on 'Unsticky this post'
    end

    # Reopen and confirm we're back to "Make sticky"
    within(first('.status')) do
      find('button[title="More"]').click_button
    end

    within('.dropdown-menu') do
      expect(page).to have_text('Make this post globally sticky')
    end

    expect(Sticky.exists?(status_id: target_status.id)).to be false
  end
end
