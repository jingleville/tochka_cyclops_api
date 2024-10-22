require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    class BeneficiaryData < Dry::Validation::Contract
      params do
        required(:name).value(:string)
        required(:kpp).value(:string)
        optional(:ogrn).value(:string)
      end
    end

    class CreateBeneficiaryUl < Dry::Validation::Contract
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