# frozen_string_literal: true

require 'dry-validation'

module TochkaCyclopsApi
  module Schemas
    module Responses
      # Response schema for update_beneficiary_fl request
      class UpdateBeneficiaryFl < Dry::Struct
        # Schema for beneficiary field of main response
        class BeneficiaryData < Dry::Struct
          attribute :inn, Types::Strict::String
          attribute :id, Types::Strict::String
        end

        attribute :beneficiary, BeneficiaryData
      end
    end
  end
end
