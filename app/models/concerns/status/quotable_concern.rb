# frozen_string_literal: true

# Determine whether a status can be quoted by a given account
module Status::QuotableConcern
  extend ActiveSupport::Concern

  included do
    def quotable?
      if current_user?
        !noquote && !filtered && distributable?
      else
        false
      end
    end
  end

  def noquote
    # whether the account has #NoQuote tag in bio
    false
  end

  def filtered
    # whether the account has filtered notifications from us
    false
  end
end
