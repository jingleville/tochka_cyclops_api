# frozen_string_literal: true

require 'dry-struct'

module TochkaCyclopsApi
  module Schemas
    module Responses
      # Response schema for echo request
      class Echo
        attr_accessor :text

        def initialize(text)
          @text = text
        end
      end
    end
  end
end
