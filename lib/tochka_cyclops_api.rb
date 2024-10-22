# frozen_string_literal: true

require_relative 'tochka_cyclops_api/data_processor'
require_relative 'tochka_cyclops_api/configuration'
require_relative "tochka_cyclops_api/version"

module TochkaCyclopsApi
  class Error < StandardError; end

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
