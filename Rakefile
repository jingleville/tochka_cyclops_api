# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

require_relative 'lib/tochka_cyclops_api/methods'

RuboCop::RakeTask.new

task default: :rubocop

task :methods do
  puts TochkaCyclopsApi::METHODS
end