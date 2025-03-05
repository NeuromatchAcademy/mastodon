# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Settings::ProfilesController do
  render_views

  let!(:user) { Fabricate(:user) }
  let(:account) { user.account }

  before do
    sign_in user, scope: :user
  end

  describe 'PUT #account_css with custom css' do
    it 'hopefully removes malicious css' do
      put :update, params: {
        account: {
          account_css: <<~CSS,
            @import url(swear_words.css);
            a { text-decoration: none; }

            a:hover {
            left: expression(alert('xss!'));
            text-decoration: underline;
            }
          CSS
        },
      }
      expect(account.reload.account_css).to eq <<~CSS

        a { text-decoration: none; }

        a:hover {

        text-decoration: underline;
        }
      CSS
    end
  end
end
