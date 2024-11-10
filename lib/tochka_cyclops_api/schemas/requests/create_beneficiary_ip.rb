# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Requests
      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-ip
      class CreateBeneficiaryIp < Dry::Validation::Contract
        # Schema for beneficiary_data field of main schema
        class BeneficiaryData < Dry::Validation::Contract
          params do
            required(:first_name).value(:string)
            required(:last_name).value(:string)
            optional(:middle_name).value(:string)
          end
        end

        schema do
          required(:inn).value(:string)
          optional(:nominal_account_code).value(:string)
          optional(:nominal_account_bic).value(:string)
          required(:beneficiary_data).schema(
            TochkaCyclopsApi::Schemas::Requests::CreateBeneficiaryIp::BeneficiaryData.schema
          )
        end

        EXAMPLE =
"{
  inn: '7743745038',
  nominal_account_code: '40702810338170022645',
  nominal_account_bic: '044525225',
  beneficiary_data: {
    first_name: 'Иван',
    last_name: 'Иванов',
    middle_name: 'Иванович'
  }
}"
      end
    end
  end
end
