# frozen_string_literal: true

require 'uri'
require 'net/http'
require_relative 'response'

module TochkaCyclopsApi
  # Module for sending requests to the bank's api
  module Request
    def self.send(body, method)
      @method = method
      initialize_request(body)

      uri = URI('https://pre.tochka.com/api/v1/cyclops/v2/jsonrpc')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri, {
        'sign-data' => signature(body),
        'sign-thumbprint' => TochkaCyclopsApi.configuration.sign_thumbprint,
        'sign-system' => TochkaCyclopsApi.configuration.sign_system,
        'Content-Type' => 'application/pdf'
      })
      request.body = body

      response = http.request(request)

      case response.code.to_i
      when (200..299)
        @request.update(status: 'finished')
        TochkaCyclopsApi::Response.create(@request, response, method)
      when (400..499)
        -> { 'Our server error' }[]
      else
        @request.update(status: 'failed')
        -> { 'Their server error' }[]
      end
    end

    def self.signature(body)
      digest = OpenSSL::Digest.new('sha256')
      private_key = OpenSSL::PKey::RSA.new(TochkaCyclopsApi.configuration.private_key)
      signature_key = private_key.sign(digest, body)
      base64_signature = Base64.strict_encode64(signature_key)
      base64_signature.gsub("\n", '')
    end

    def self.initialize_request(body)
      @request = TochkaCyclopsRequest.create(
        method: @method,
        body: body,
        request_identifier: @id,
        # idempotency_key:
        status: 'initialized'
      )
    end
  end
end
