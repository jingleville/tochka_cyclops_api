# frozen_string_literal: true

module TochkaCyclopsApi
  # Configuration class
  class Configuration
    attr_accessor :certificate, :private_key, :sign_system, :sign_thumbprint
  end
end
