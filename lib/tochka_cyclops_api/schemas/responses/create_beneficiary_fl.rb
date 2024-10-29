require 'dry-struct'

module Types
  include Dry.Types()
end

module TochkaCyclopsApi
  module Schemas
    module Responses
      # Schema for beneficiary field of main response
      class BeneficiaryData < Dry::Struct
        attribute :inn, Types::Strict::String
        attribute :id, Types::Strict::String
        attribute :nominal_account_code, Types::Strict::String.optional
        attribute :nominal_account_bic, Types::Strict::String.optional
      end

      # Response chema for create_beneficiary_fl request
      class CreateBeneficiaryFl < Dry::Struct
        attribute :beneficiary, BeneficiaryData
      end
    end
  end
end