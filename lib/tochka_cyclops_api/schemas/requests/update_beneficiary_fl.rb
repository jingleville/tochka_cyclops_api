# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Requests
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

      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-ip
      class UpdateBeneficiaryFl < Dry::Validation::Contract
        schema do
          required(:beneficiary_id).value(:string)
          required(:beneficiary_data).schema(
            TochkaCyclopsApi::Schemas::Requests::BeneficiaryData.schema
          )
        end
      end
    end
  end
end
