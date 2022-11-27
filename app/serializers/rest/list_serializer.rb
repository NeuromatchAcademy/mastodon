# frozen_string_literal: true

class REST::ListSerializer < ActiveModel::Serializer
  attributes :id, :title, :replies_policy, :exclusive, :autopopulate

  def id
    object.id.to_s
  end
end
