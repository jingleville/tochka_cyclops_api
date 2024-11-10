# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Requests
      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-ul
      class CreateBeneficiaryUl < Dry::Validation::Contract
        # Schema for beneficiary_data field of main schema
        class BeneficiaryData < Dry::Validation::Contract
          params do
            required(:name).value(:string)
            required(:kpp).value(:string)
            optional(:ogrn).value(:string)
          end
        end

        schema do
          required(:inn).value(:string)
          optional(:nominal_account_code).value(:string)
          optional(:nominal_account_bic).value(:string)
          required(:beneficiary_data).schema(
            TochkaCyclopsApi::Schemas::Requests::CreateBeneficiaryUl::BeneficiaryData.schema
          )
        end

        EXAMPLE =
"{
  inn: '7743745038',
  nominal_account_code: '40702810338170022645',
  nominal_account_bic: '044525225',
  beneficiary_data: {
    name: 'ООО «ТК ИнжСтройКомплект»',
    kpp: '773401001',
    ogrn: '1097746324169'
  }
}"
      end
    end
  end
end
