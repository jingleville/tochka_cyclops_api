# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Requests
      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-update-beneficiary-fl
      class UpdateBeneficiaryFl < Dry::Validation::Contract
        # Schema for beneficiary_data field of main schema
        class BeneficiaryData < Dry::Validation::Contract
          params do
            required(:first_name).value(:string)
            required(:last_name).value(:string)
            required(:birth_date).value(:string)
            required(:birth_place).value(:string)
            required(:passport_number).value(:string)
            required(:passport_date).value(:string)
            required(:registration_address).value(:string)

            optional(:passport_series).value(:string)
            optional(:middle_name).value(:string)
            optional(:resident).value(:bool)
          end
        end

        schema do
          required(:beneficiary_id).value(:string)
          required(:beneficiary_data).schema(
            TochkaCyclopsApi::Schemas::Requests::UpdateBeneficiaryFl::BeneficiaryData.schema
          )
        end

        EXAMPLE = "
{
  beneficiary_id: '981fee11-9969-4e80-9f5f-02af462cb51e',
  beneficiary_data: {
      first_name: 'Иван',
      last_name: 'Иванов',
      birth_date: '1990-01-24',
      birth_place: 'г. Свердловск',
      passport_series: '6509',
      passport_number: '123456',
      passport_date: '2020-01-01',
      registration_address: '683031, г. Петропавловск-Камчатский, пр-кт. Карла Маркса, д. 21/1, офис 305'
  }
}"
      end
    end
  end
end
