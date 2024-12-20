# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

module TochkaCyclopsApi
  module Schemas
    module Responses
      # Response schema for update_beneficiary_ul request
      class UpdateBeneficiaryUl < Dry::Struct
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
