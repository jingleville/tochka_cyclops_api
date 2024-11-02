# frozen_string_literal: true
require 'dry-types'
require 'dry-validation'

require_relative 'tochka_cyclops_api/generators/models_generator'
require_relative 'tochka_cyclops_api/generators/initializer_generator'

require_relative 'tochka_cyclops_api/data_processor'
require_relative 'tochka_cyclops_api/configuration'
require_relative 'tochka_cyclops_api/version'
require_relative 'tochka_cyclops_api/methods'
require_relative 'tochka_cyclops_api/test'

# Core module of this gem
module TochkaCyclopsApi
  class Error < StandardError; end

  module Types
    include Dry.Types()
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def send_request(method: ,data: , layer: )
      DataProcessor.send_request(method: ,data: , layer: )
    end
  end
end
