# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Requests
      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#echo
      class Echo < Dry::Validation::Contract
        schema do
          required(:text).value(:string)
        end

        EXAMPLE = "{ text: 'Echo' }"
      end
    end
  end
end
