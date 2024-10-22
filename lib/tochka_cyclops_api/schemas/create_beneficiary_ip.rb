require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    class BeneficiaryData < Dry::Validation::Contract
      params do
        required(:first_name).value(:string)
        required(:last_name).value(:string)
        optional(:middle_name).value(:string)
      end
    end

    class CreateBeneficiaryIp < Dry::Validation::Contract
      schema do
        required(:inn).value(:string)
        optional(:nominal_account_code).value(:string)
        optional(:nominal_account_bic).value(:string)
        required(:beneficiary_data).schema(
          TochkaCyclopsApi::Schemas::BeneficiaryData.schema)
      end
    end
  end
end