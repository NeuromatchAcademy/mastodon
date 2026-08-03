# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profile' do
  include ProfileStories

  before do
    as_a_logged_in_user
    Fabricate(:user, account: Fabricate(:account, username: 'alice'))
  end

  it 'I can view public account page for Alice' do
    visit account_path('alice')

    expect(page)
      .to have_title("alice (@alice@#{local_domain_uri.host})")
  end

  # These profile stories tests got moved somewhere else at some point,
  # but i don't know exactly where, so this is pretty fragile -jls
  describe 'with JS', :js, :streaming do
    before do
      with_chupacabras_fancy_profile
    end

    it 'Can have custom account_css set' do
      visit account_path('chupacabra')
      # wait for page to load...
      page.find '._comp_account_header__header'
      expect(page.html).to have_text('background-color: red !important')

      visit account_path('bob')
      page.find '._comp_account_header__header'
      expect(page.html).to have_no_text('background-color: red !important')
    end
  end
end
