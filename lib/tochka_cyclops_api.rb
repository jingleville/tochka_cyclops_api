# frozen_string_literal: true
require 'dry-types'

require_relative 'tochka_cyclops_api/data_processor'
require_relative 'tochka_cyclops_api/configuration'
require_relative 'tochka_cyclops_api/version'
require_relative 'tochka_cyclops_api/methods'

# Core module of this gem
module TochkaCyclopsApi
  class Error < StandardError; end

  module Types
    include Dry.Types()
  end

  class << self
    include DataProcessor

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
