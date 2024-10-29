# frozen_string_literal: true

require_relative './schemas/responses/echo'

module TochkaCyclopsApi
  # Class for processing the response received from the api bank
  class Response
    def self.create(request, response, method)
      @method = method
      @request = request
      @response = response
      parse

      {
        response_struct: @response_struct,
        result: @result
      }
    end

    def self.parse
      @body = JSON.parse(@response.body)
      if @body.key? 'result'
        parse_result
      elsif @body.key? 'error'
        parse_error
      end
    end

    def self.parse_result
      @result = @body['result']
      response_schema = schema || -> { "Schema for #{@method} is not found" }[]

      @response = TochkaCyclopsResponse.create(body: @body, result: @result)
      @request.update(result: @response)
      @result.deep_symbolize_keys if @result.is_a? Hash
      @response_struct = response_schema.new(@result)
    end

    def self.parse_error
      @error = @body['error']
      require_relative './schemas/responses/error'
      response_schema = 'TochkaCyclopsApi::Schemas::Responses::Error'.constantize

      @response = TochkaCyclopsError.create(
        body: @body,
        code: @error['code'],
        message: @error['message']
      )

      @request.update(result: @response)

      @response_struct = response_schema.new(@error.deep_symbolize_keys)
    end

    def self.schema
      require_relative "./schemas/responses/#{@method}"
      "TochkaCyclopsApi::Schemas::Responses::#{camel_case_method}".constantize
    rescue StandardError => e
      @errors = { error: e.message }
      false
    end

    def self.camel_case_method
      @method.split('_').map(&:capitalize).join
    end
  end
end
