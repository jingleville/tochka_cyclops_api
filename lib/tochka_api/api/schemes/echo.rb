require 'dry-validation'

module TochkaApi
  module API
    module Schemes
      class Echo < Dry::Validation::Contract
        schema do
          required(:text).value(:string)
        end
      end
    end
  end
end