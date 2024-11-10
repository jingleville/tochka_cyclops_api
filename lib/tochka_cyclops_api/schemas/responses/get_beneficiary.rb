# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types()
end

module TochkaCyclopsApi
  module Schemas
    module Responses
      # Response schema for get_beneficiary request
      class ListBeneficicary < Dry::Struct
        class LastContractOffer < Dry::Struct
          attribute :id, ::Types::String
          attribute :type, ::Types::String
          attribute :success_added, ::Types::Bool
          attribute :success_added_desc, ::Types::String
        end

        class NominalAccount < Dry::Struct
          attribute :bic, ::Types::String
          attribute :code, ::Types::String
        end

        class BeneficiaryData < Dry::Struct
          attribute :name, ::Types::String
        end

        class Beneficiary < Dry::Struct
          attribute :inn, Types::String
          attribute :id, Types::String
          attribute :is_active, Types::Bool
          attribute :legal_type, Types::String
          attribute :ogrn, Types::String
          attribute :beneficiary_data, BeneficiaryData
        end

        attribute :beneficiary, Beneficiary
        attribute :nominal_account, NominalAccount
        attribute :last_contract_offer, LastContractOffer
        attribute :permission, Types::Bool
        attribute :permission_description, Types::String
        attribute :meta, Meta
      end
    end
  end
end
