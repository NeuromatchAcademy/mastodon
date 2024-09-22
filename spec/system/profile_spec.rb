# frozen_string_literal: true

require 'rails_helper'

describe 'Profile' do
  include ProfileStories

  subject { page }

  let(:local_domain) { Rails.configuration.x.local_domain }

  before do
    as_a_logged_in_user
    with_alice_as_local_user
  end

  it 'I can view Annes public account' do
    visit account_path('alice')

    expect(subject).to have_title("alice (@alice@#{local_domain})")
  end

  it 'I can change my account' do
    visit settings_profile_path

    fill_in 'Display name', with: 'Bob'
    fill_in 'Bio', with: 'Bob is silent'

    first('button[type=submit]').click

    expect(subject).to have_content 'Changes successfully saved!'
  end

  describe 'with JS', :js, :streaming do
    before do
      with_chupacabras_fancy_profile
    end

    it 'Can have custom account_css set' do
      visit account_path('chupacabra')
      # wait for page to load...
      page.find '.account__header'
      expect(subject.html).to have_content('background-color: red !important')

      visit account_path('bob')
      page.find '.account__header'
      expect(subject.html).to have_no_content('background-color: red !important')
    end
  end
end
