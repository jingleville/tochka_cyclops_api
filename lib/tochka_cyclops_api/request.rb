# frozen_string_literal: true

require 'uri'
require 'net/http'
require_relative 'response'

module TochkaCyclopsApi
  # Module for sending requests to the bank's api
  class Request
    def self.send_request(body:, method:, url: )
      @method = method
      @body = body
      @uri = URI(url)
      @request_object = initialize_request_object
      @post_request = initialize_post_request
      @adapter = initialize_adapter

      call
    end

    private

    def self.call
      get_response
      response = handle_response

      case response[:status]
      when :error
        Result.failure(response[:data])
      else
        Response.new(request: @request_object, response: response[:data], method: @method)
      end
    end

    def self.initialize_adapter
      adapter = Net::HTTP.new(@uri.host, @uri.port)
      adapter.use_ssl = true
      adapter
    end

    def self.initialize_request_object
      TochkaCyclopsRequest.create(
        method: @method,
        body: @body,
        request_identifier: @id,
        # idempotency_key:
        status: 'initialized'
      )
    end

    def self.initialize_post_request
      post_request = Net::HTTP::Post.new(@uri, {
        'sign-data' => signature,
        'sign-thumbprint' => TochkaCyclopsApi.configuration.sign_thumbprint,
        'sign-system' => TochkaCyclopsApi.configuration.sign_system,
        'Content-Type' => 'application/json'
      })
      post_request.body = @body
      post_request
    end

    def self.get_response
      @response = @adapter.request(@post_request)
    rescue => e
      @error = { request_error: e }
    end

    def self.handle_response
      return { status: :error, data: @error } if @error

      status =  case @response.code.to_i
                when (200..299)
                  {
                    status: :ok,
                    data: @response
                  }
                else
                  {
                    status: :error,
                    data: { request_error: @response }
                  }
                end
    end

    def self.signature
      digest = OpenSSL::Digest.new('sha256')
      private_key = OpenSSL::PKey::RSA.new(TochkaCyclopsApi.configuration.private_key)
      signature_key = private_key.sign(digest, @body)
      base64_signature = Base64.strict_encode64(signature_key)
      base64_signature.gsub("\n", '')
    end
  end
end
