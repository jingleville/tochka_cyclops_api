require_relative '../response'
require_relative 'schemes/echo'

module Request
  def send(method, data)
    @method = method
    @data = data
    unless valid_params?
      return @errors.map{ |k,v| [k, v].join(' ')}.join(', ')
    end

    uri = URI('https://pre.tochka.com/api/v1/cyclops/v2/jsonrpc')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri, {
      'sign-data'       => signature,
      'sign-thumbprint' => TochkaApi.configuration.sign_thumbprint,
      'sign-system'     => TochkaApi.configuration.sign_system,
      'Content-Type'    => 'application/pdf'
    })
    request.body = body

    TochkaApi::Response.new(http.request(request))
  end

  private

  def signature
    digest = OpenSSL::Digest.new('sha256')
    private_key = OpenSSL::PKey::RSA.new(File.read(TochkaApi.configuration.private_key_path))
    signature_key = private_key.sign(digest, body)
    base64_signature = Base64.strict_encode64(signature_key)
    base64_signature.gsub("\n", '')
  end

  def body
    {
      "jsonrpc": "2.0",
      "method": @method,
      "params": @data,
      "id": "908ca508-f1f1-4256-9c43-9ba7ad9c45fb"
    }.to_json
  end

  def valid_params?
    if shape.present?
      result = shape.call(@data)
      @errors = result.errors.to_h
    end

    @errors.empty?
  end

  def shape
    begin
      schema = ('TochkaApi::API::Schemes::' + @method.capitalize).constantize
      schema.new
    rescue => e
      @errors = {error: e.message}
      false
    end
  end
end

