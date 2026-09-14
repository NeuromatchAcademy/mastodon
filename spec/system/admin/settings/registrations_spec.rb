# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Settings::Registrations' do
  let(:admin_user) { Fabricate(:admin_user) }

  before { sign_in(admin_user) }

  it 'Saves changes to registrations settings' do
    visit admin_settings_registrations_path
    expect(page)
      .to have_title(I18n.t('admin.settings.registrations.title'))

    select open_mode_option,
           from: registrations_mode_field

    click_on submit_button

    expect(page)
      .to have_text(success_message)
  end

  it 'Saves a custom reason-to-join message' do
    visit admin_settings_registrations_path

    fill_in registration_reason_message_field,
            with: 'Tell us which lab you work in'

    click_on submit_button

    expect(page)
      .to have_text(success_message)
    expect(Setting.registration_reason_message)
      .to eq('Tell us which lab you work in')
  end

  def open_mode_option
    I18n.t('admin.settings.registrations_mode.modes.open')
  end

  def registrations_mode_field
    form_label 'form_admin_settings.registrations_mode'
  end

  def registration_reason_message_field
    form_label 'form_admin_settings.registration_reason_message'
  end
end
