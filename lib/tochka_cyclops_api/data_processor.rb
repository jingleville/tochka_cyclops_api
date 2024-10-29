# frozen_string_literal: true

require 'active_support/inflector'
require 'active_support'
require 'securerandom'
require 'json'

require_relative 'request'
require_relative './generators/model_generator'
require_relative './schemas/requests/echo'

module TochkaCyclopsApi
  # Module for input data validation and subsequent request invocation
  module DataProcessor
    def send_request(method, data)
      @method = method
      @data = data
      @id = SecureRandom.uuid

      return @errors.map { |k, v| [k, v].join(' ') }.join(', ') unless valid_params?

      send_data
    end

    private

    def valid_params?
      if shape
        result = shape.call(@data.deep_symbolize_keys)
        @errors = result.errors.to_h
      end

      @errors.empty?
    end

    def send_data
      TochkaCyclopsApi::Request.send(body, @method)
    end

    def shape
      require_relative "./schemas/requests/#{@method}"
      schema = ['TochkaCyclopsApi', 'Schemas', 'Requests', camel_case_method].join('::').constantize

      schema.new
    rescue => e
      @errors = { error: e.message }
      false
    end

    def camel_case_method
      @method.split('_').map(&:capitalize).join
    end

    def body
      {
        "jsonrpc": '2.0',
        "method": @method,
        "params": @data,
        "id": @id
      }.to_json
    end
  end
end
