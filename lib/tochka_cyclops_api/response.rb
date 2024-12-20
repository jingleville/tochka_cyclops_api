# frozen_string_literal: true

require_relative 'schemas/responses/error'

module TochkaCyclopsApi
  # Class for processing the response received from the api bank
  class Response
    def self.create(request: ,response: ,method:)
      @request = request
      @method = method
      @body = JSON.parse(response.body)
      @response_schema = "TochkaCyclopsApi::Schemas::Responses::#{camel_case_method}".constantize
      @error_schema = 'TochkaCyclopsApi::Schemas::Responses::Error'.constantize

      call
    end

    private

    def self.call
      @result = @body['result']
      @error = @body['error']

      if @error.present?
        parse_error
      else
        parse_result
      end
    end

    def self.parse_result
      return nil if @result.nil?

      response = TochkaCyclopsResponse.create(body: @body, result: @result)
      @request.update(result: response, status: 'success')
      @result.deep_symbolize_keys if @result.is_a? Hash
      response_struct = @response_schema.new(@result)

      Result.success(response_struct)
    end

    def self.parse_error
      return nil if @error.nil?

      response = TochkaCyclopsError.create(
        body: @body,
        code: @error['code'],
        message: @error['message']
      )
      @request.update(result: response, status: 'failure')
      response_struct = @error_schema.new(@error.deep_symbolize_keys)

      Result.success(response_struct)
    end

    def self.camel_case_method
      @method.split('_').map(&:capitalize).join
    end
  end
end
