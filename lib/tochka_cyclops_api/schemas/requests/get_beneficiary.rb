# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Requests
      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-get-beneficiary
      class GetBeneficiary < Dry::Validation::Contract
        schema do
          required(:beneficiary_id).value(:string)
        end

        EXAMPLE = "
{
  beneficiary_id: '981fee11-9969-4e80-9f5f-02af462cb51e'
}
"
      end
    end
  end
end
