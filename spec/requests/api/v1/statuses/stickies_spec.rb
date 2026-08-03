# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stickies' do
  let(:user)    { Fabricate(:moderator_user) }
  let(:scopes)  { 'write:statuses' }
  let(:token)   { Fabricate(:accessible_access_token, resource_owner_id: user.id, scopes: scopes) }
  let(:headers) { { 'Authorization' => "Bearer #{token.token}" } }

  describe 'POST /api/v1/statuses/:status_id/sticky' do
    subject do
      post "/api/v1/statuses/#{status.id}/sticky", headers: headers
    end

    let(:status) { Fabricate(:status) }

    it_behaves_like 'forbidden for wrong scope', 'read'

    context 'when a moderator' do
      it 'creates a sticky and returns updated json with sticky: true', :aggregate_failures do
        subject

        expect(response).to have_http_status(200)
        expect(Sticky.exists?(status_id: status.id)).to be true
        expect(response.parsed_body).to match(
          a_hash_including(id: status.id.to_s, sticky: true)
        )
        expect(response.parsed_body.keys.map(&:to_s)).to include('sticky')
      end

      it 'is idempotent when called twice' do
        subject
        expect { post "/api/v1/statuses/#{status.id}/sticky", headers: headers }
          .to_not change(Sticky, :count)
        expect(response).to have_http_status(200)
      end
    end

    context 'when a regular user' do
      let(:user) { Fabricate(:user) }

      it 'returns http forbidden' do
        subject
        expect(response).to have_http_status(403)
      end
    end

    context 'without an authorization header' do
      let(:headers) { {} }

      it 'returns http unauthorized' do
        subject
        expect(response).to have_http_status(401)
      end
    end

    context 'when the status does not exist' do
      it 'returns http not found' do
        post '/api/v1/statuses/-1/sticky', headers: headers
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /api/v1/statuses/:status_id/unsticky' do
    subject do
      post "/api/v1/statuses/#{status.id}/unsticky", headers: headers
    end

    let(:status) { Fabricate(:status) }

    it_behaves_like 'forbidden for wrong scope', 'read'

    context 'when a moderator' do
      context 'when the status is currently sticky' do
        before { Sticky.create!(status: status) }

        it 'removes the sticky and returns updated json with sticky: false', :aggregate_failures do
          subject

          expect(response).to have_http_status(200)
          expect(Sticky.exists?(status_id: status.id)).to be false
          expect(response.parsed_body).to match(
            a_hash_including(id: status.id.to_s, sticky: false)
          )
        end
      end

      context 'when the status is not sticky' do
        it 'returns http success without error' do
          subject
          expect(response).to have_http_status(200)
          expect(response.parsed_body).to match(
            a_hash_including(id: status.id.to_s, sticky: false)
          )
        end
      end
    end

    context 'when a regular user' do
      let(:user) { Fabricate(:user) }

      before { Sticky.create!(status: status) }

      it 'returns http forbidden and does not remove the sticky', :aggregate_failures do
        subject
        expect(response).to have_http_status(403)
        expect(Sticky.exists?(status_id: status.id)).to be true
      end
    end
  end
end
