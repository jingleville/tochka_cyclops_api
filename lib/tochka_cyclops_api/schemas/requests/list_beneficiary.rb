# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Requests
      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-list-beneficiary
      class ListBeneficiary < Dry::Validation::Contract
        # Schema for beneficiary_data field of main schema
        class Filters < Dry::Validation::Contract
          params do
            optional(:inn).value(:string)
            optional(:is_active).value(:bool)
            optional(:legal_type).value(:string)
            optional(:nominal_account_code).value(:string)
            optional(:nominal_account_bic).value(:string)
          end
        end

        schema do
          optional(:page).value(:integer)
          optional(:per_page).value(:integer)
          optional(:filters).schema(
            TochkaCyclopsApi::Schemas::Requests::ListBeneficiary::Filters.schema
          )
        end

        EXAMPLE = "
{
  page: 2,
  per_page: 20,
  filters: {
    is_active: true,
    legal_type: 'F',
    nominal_account_code: '000000000000000000000',
    nominal_account_bic: '0000000000',
  }
}
"
      end
    end
  end
end
