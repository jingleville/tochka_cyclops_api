require 'active_support/inflector'
require 'json'

require_relative 'request'
require_relative 'schemas/echo'

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
        schema = ('TochkaCyclopsApi::Schemas::' + @method.capitalize).constantize
        schema.new
      rescue => e
        @errors = {error: e.message}
        false
      end
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
