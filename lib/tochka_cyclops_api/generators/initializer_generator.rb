require 'rails/generators/base'

module TochkaCyclopsApi
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      desc 'It creates an initializer to set config data'
      def create_initializer_file
        create_file(
          'config/initializers/tochka_cyclops_api.rb',
          <<~TOCHKA_CYCLOPS_API_INITIALIZER_TEXT
            # frozen_string_literal: true

            TochkaCyclopsApi.configure do |config|
              config.certificate = File.read() # PATH TO TOCHKA CERTIFICATE
              config.private_key = File.read() # PATH TO TOCHKA PRIVATE KEY
              config.sign_thumbprint = '' # YOUR THUMBPRINT
              config.sign_system = '' # YOUR SYSTEM
            end
          TOCHKA_CYCLOPS_API_INITIALIZER_TEXT
        )
      end
    end
  end
end
