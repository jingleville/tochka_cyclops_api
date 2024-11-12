# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Requests
      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-update-beneficiary-ip
      class UpdateBeneficiaryIp < Dry::Validation::Contract
        # Schema for beneficiary_data field of main schema
        class BeneficiaryData < Dry::Validation::Contract
          params do
            required(:first_name).value(:string)
            required(:last_name).value(:string)
            optional(:middle_name).value(:string)
          end
        end

        schema do
          required(:beneficiary_id).value(:string)
          required(:beneficiary_data).schema(
            TochkaCyclopsApi::Schemas::Requests::UpdateBeneficiaryIp::BeneficiaryData.schema
          )
        end

        EXAMPLE = "
{
  beneficiary_id: '981fee11-9969-4e80-9f5f-02af462cb51e',
  beneficiary_data: {
    first_name: 'Иван',
    middle_name: 'Иванович',
    last_name: 'Иванов'
  }
}
"
      end
    end
  end
end
