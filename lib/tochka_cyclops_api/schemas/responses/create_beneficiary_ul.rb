# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

module TochkaCyclopsApi
  module Schemas
    module Responses
      # Response schema for create_beneficiary_ul request
      class CreateBeneficiaryUl < Dry::Struct
        # Schema for beneficiary field of main response
        class BeneficiaryData < Dry::Struct
          attribute :inn, Types::Strict::String
          attribute :id, Types::Strict::String
          attribute :nominal_account_code, Types::Strict::String.optional
          attribute :nominal_account_bic, Types::Strict::String.optional
        end

        attribute :beneficiary, BeneficiaryData
      end
    end
  end
end
