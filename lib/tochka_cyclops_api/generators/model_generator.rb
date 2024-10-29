# frozen_string_literal: true

# lib/generators/model_generator.rb

require 'rails/generators'
require 'rails/generators/migration'

require_relative './templates/tochka_cyclops_error_model_template'
require_relative './templates/tochka_cyclops_request_model_template'
require_relative './templates/tochka_cyclops_response_model_template'
require_relative './templates/tochka_cyclops_errors_migration_template'
require_relative './templates/tochka_cyclops_requests_migration_template'
require_relative './templates/tochka_cyclops_responses_migration_template'

module TochkaCyclopsApi
  module Generators
    # Class for core generators
    class ModelsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      def create_model_file
        require 'active_record'

        template 'tochka_cyclops_error_model_template.rb', 'app/models/tochka_cyclops_error.rb'
        template 'tochka_cyclops_request_model_template.rb', 'app/models/tochka_cyclops_request.rb'
        template 'tochka_cyclops_response_model_template.rb', 'app/models/tochka_cyclops_response.rb'
      end

      def create_migration_file
        migration_template 'tochka_cyclops_errors_migration_template.rb', 'db/migrate/create_tochka_cyclops_errors.rb'
        migration_template 'tochka_cyclops_requests_migration_template.rb',
                           'db/migrate/create_tochka_cyclops_requests.rb'
        migration_template 'tochka_cyclops_responses_migration_template.rb',
                           'db/migrate/create_tochka_cyclops_responses.rb'
      end

      def self.next_migration_number(_path)
        sleep(1)
        Time.now.utc.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end
