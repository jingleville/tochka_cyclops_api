# frozen_string_literal: true

# RequestModel generator
class TochkaCyclopsRequest < ActiveRecord::Base
  belongs_to :result, polymorphic: true
  enum :status, %w[initialized failure success]
end
