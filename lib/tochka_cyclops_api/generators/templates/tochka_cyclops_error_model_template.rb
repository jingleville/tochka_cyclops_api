# frozen_string_literal: true

# ErrorModel generator
class TochkaCyclopsError < ActiveRecord::Base
  has_one :request, class_name: 'TochkaCyclopsRequest', as: :result
end
