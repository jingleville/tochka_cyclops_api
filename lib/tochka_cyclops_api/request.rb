require 'uri'
require 'net/http'
require_relative 'response'

module TochkaCyclopsApi
  module Request
    def self.send(body)
      uri = URI('https://pre.tochka.com/api/v1/cyclops/v2/jsonrpc')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri, {
        'sign-data'       => signature(body),
        'sign-thumbprint' => TochkaCyclopsApi.configuration.sign_thumbprint,
        'sign-system'     => TochkaCyclopsApi.configuration.sign_system,
        'Content-Type'    => 'application/pdf'
      })
      request.body = body

      TochkaCyclopsApi::Response.new(http.request(request))
    end

    private

    def self.signature(body)
      digest = OpenSSL::Digest.new('sha256')
      private_key = OpenSSL::PKey::RSA.new(TochkaCyclopsApi.configuration.private_key)
      signature_key = private_key.sign(digest, body)
      base64_signature = Base64.strict_encode64(signature_key)
      base64_signature.gsub("\n", '')
    end
  end
end
