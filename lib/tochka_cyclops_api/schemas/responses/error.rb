# frozen_string_literal: true

require 'dry-struct'

module TochkaCyclopsApi
  module Schemas
    module Responses
      # Response chema for bank's api errors
      class Error < Dry::Struct
        attribute :code, Types::Strict::Integer
        attribute :message, Types::Strict::String
        attribute :meta, Types::Strict::Array
      end
    end
  end
end
