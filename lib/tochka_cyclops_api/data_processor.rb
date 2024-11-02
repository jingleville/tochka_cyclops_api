# frozen_string_literal: true

require 'active_support/inflector'
require 'active_support'
require 'securerandom'
require 'json'

require_relative 'request'
require_relative 'result'
require_relative 'schemas/requests/echo'

module TochkaCyclopsApi
  # Module for input data validation and subsequent request invocation
  module DataProcessor
    def send_request(method:, data:, layer: prod)
      @uri = uri_for(layer)
      @method = method
      @data = data
      @id = SecureRandom.uuid
      @schema = shape
      @validation = @schema&.call(@data.deep_symbolize_keys)
      @errors = {}

      call
    end

    private

    def call
      @errors[:uri] = "Layer you called for is not exist" if @uri.nil?
      @errors[:schema] = "Schema for method #{@method} is not found" if @schema.nil?

      if @schema
        @errors[:validation] = validation.errors.to_h
      end

      if @errors.keys.any?
        return Result.new(result: nil, errors: @errors)
      end

      send_data
    end

    def send_data
      TochkaCyclopsApi::Request.send_request(method: @method, body: body)
    end

    def uri_for(layer)
      {
        stage: 'https://stage.tochka.com/api/v1/cyclops',
        pre: 'https://pre.tochka.com/api/v1/cyclops',
        prod: 'https://api.tochka.com/api/v1/cyclops'
      }.fetch(layer, nil)
    end



    def validate_params(schema)
      schema.call(@data.deep_symbolize_keys)
    end

    # def valid_params?(schema)
    #   if shape
    #     result = shape.call(@data.deep_symbolize_keys)
    #     @error = Error.new(
    #       'Invalid schema',
    #       result.errors.to_h
    #     )
    #   end

    #   @error.description.nil?
    # end

    def shape
      require_relative "schemas/requests/#{@method}"
      schema = ['TochkaCyclopsApi', 'Schemas', 'Requests', camel_case_method].join('::').constantize

      schema.new
    rescue => e
      nil
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
