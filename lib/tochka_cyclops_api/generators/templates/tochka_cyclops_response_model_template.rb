# frozen_string_literal: true

# ResponseModel generator
class TochkaCyclopsResponse < ActiveRecord::Base
  has_one :request, class_name: 'TochkaCyclopsRequest', as: :result
end
