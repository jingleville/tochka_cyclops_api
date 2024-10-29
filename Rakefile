# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

require_relative 'lib/tochka_cyclops_api/methods'

RuboCop::RakeTask.new

task default: :rubocop

namespace :generate do
  task :models do
    sh 'rails generate tochka_cyclops_api:model'
  end

  task :config do
    root_path = Rails.root
    config_path = root_path.join('config/tochka_cyclops_api.rb')

    sh "touch #{config_path}"
  end
end

task :methods do
  puts TochkaCyclopsApi::METHODS
end