# frozen_string_literal: true

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
      end

      # Response chema for create_beneficiary_ul request
      class UpdateBeneficiaryUl < Dry::Struct
        attribute :beneficiary, BeneficiaryData
      end
    end
  end
end
