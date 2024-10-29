# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Requests
      # Schema for beneficiary_data field of main schema
      class BeneficiaryData < Dry::Validation::Contract
        params do
          required(:name).value(:string)
          required(:kpp).value(:string)
          optional(:ogrn).value(:string)
        end
      end

      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-ul
      class CreateBeneficiaryUl < Dry::Validation::Contract
        schema do
          required(:inn).value(:string)
          optional(:nominal_account_code).value(:string)
          optional(:nominal_account_bic).value(:string)
          required(:beneficiary_data).schema(
            TochkaCyclopsApi::Schemas::Requests::BeneficiaryData.schema
          )
        end
      end
    end
  end
end
