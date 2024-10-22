module TochkaApi
  class Configuration
    attr_accessor :certificate_path
    attr_accessor :private_key_path
    attr_accessor :sign_system
    attr_accessor :sign_thumbprint
  end
end
