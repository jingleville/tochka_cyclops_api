# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

module TochkaCyclopsApi
  module Schemas
    module Responses
      # Response schema for list_beneficiary request
      class ListBeneficicary < Dry::Struct
        class Beneficiary < Dry::Struct
          attribute :inn, Types::String
          attribute :id, Types::String
          attribute :is_active, Types::Bool
          attribute :legal_type, Types::String
          attribute :nominal_account_code, Types::String
          attribute :nominal_account_bic, Types::String
        end

        class Page < Dry::Struct
          attribute :current_page, Types::Integer
          attribute :per_page, Types::Integer
        end

        class Meta < Dry::Struct
          attribute :total, Types::Integer
          attribute :page, Page
        end

        attribute :beneficiaries, Types::Array.of(Beneficiary)
        attribute :meta, Meta
      end
    end
  end
end
