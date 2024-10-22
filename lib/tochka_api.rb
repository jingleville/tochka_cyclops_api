require 'active_support/inflector'
require 'tochka_api/configuration'
require 'tochka_api/api/request'

module TochkaApi
  class << self
    include Request

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end

