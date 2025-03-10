# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DomainAllowPolicy do
  subject { described_class }

  let(:admin)   { Fabricate(:admin_user).account }
  let(:john)    { Fabricate(:account) }

  permissions :index?, :show?, :create?, :destroy? do
    context 'when admin' do
      it 'permits' do
        expect(subject).to permit(admin, DomainAllow)
      end
    end

    context 'when not admin' do
      it 'denies' do
        expect(subject).to_not permit(john, DomainAllow)
      end
    end
  end
end
