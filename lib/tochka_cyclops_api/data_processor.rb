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
  class DataProcessor
    def self.send_request(method:, data:, layer: )
      @method = method
      @data = data
      @layer = layer
      @errors = {}
      @url = url_for
      @request_id = SecureRandom.uuid
      schemas
      validation = @request_schema&.call(@data.deep_symbolize_keys)
      @validation_errors = validation&.errors.to_h

      call
    end

    private

    def self.call
      @errors[:url] = "Layer you called for is not exist" if @url.nil?
      @errors[:request_schema] = "Request schema for method #{@method} is not found" if @request_schema.nil?
      @errors[:response_schema] = "Response schema for method #{@method} is not found" if @response_schema.nil?

      @errors[:validation] = @validation_errors if @request_schemas.present?

      if @errors.keys.any?
        Result.failure(@errors)
      else
        TochkaCyclopsApi::Request.send_request(method: @method, body: body, url: @url)
      end
    end

    def self.url_for
      {
        stage: 'https://stage.tochka.com/api/v1/cyclops',
        pre: 'https://pre.tochka.com/api/v1/cyclops',
        prod: 'https://api.tochka.com/api/v1/cyclops'
      }.fetch(@layer, nil)
    end

    def self.schemas
      @request_schema = request_schema
      @response_schema = response_schema
    end

    def self.request_schema
      require_relative "schemas/requests/#{@method}"
      schema = ['TochkaCyclopsApi', 'Schemas', 'Requests', camel_case_method].join('::').constantize

      schema.new
    rescue => e
      nil
    end

    def self.response_schema
      require_relative "schemas/responses/#{@method}"
      schema = ['TochkaCyclopsApi', 'Schemas', 'Responses', camel_case_method].join('::').constantize
    rescue => e
      nil
    end

    def self.camel_case_method
      @method.split('_').map(&:capitalize).join
    end

    def self.body
      {
        "jsonrpc": '2.0',
        "method": @method,
        "params": @data,
        "id": @request_id
      }.to_json
    end
  end
end
