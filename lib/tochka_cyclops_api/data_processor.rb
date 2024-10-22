require 'active_support/inflector'
require 'json'

require_relative 'request'

require_relative 'schemas/echo'
require_relative 'schemas/create_beneficiary_ul'

module TochkaCyclopsApi
  module DataProcessor
    def send_request(method, data)
      @method = method
      @data = data

      if valid_params?
        send_data
      else
        return @errors.map{ |k,v| [k, v].join(' ')}.join(', ')
      end
    end

    private

    def valid_params?
      if shape
        result = shape.call(@data)
        @errors = result.errors.to_h
      end

      @errors.empty?
    end

    def send_data
      TochkaCyclopsApi::Request.send(body)
    end

    def shape
      begin
        schema = ('TochkaCyclopsApi::Schemas::' + camel_case_method).constantize
        schema.new
      rescue => e
        @errors = {error: e.message}
        false
      end
    end

    def camel_case_method
      @method.split('_').map(&:capitalize).join
    end

    def body
      {
        "jsonrpc": "2.0",
        "method": @method,
        "params": @data,
        "id": "908ca508-f1f1-4256-9c43-9ba7ad9c45fb"
      }.to_json
    end
  end
end
