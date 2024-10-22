require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    class Echo < Dry::Validation::Contract
      schema do
        required(:text).value(:string)
      end
    end
  end
end