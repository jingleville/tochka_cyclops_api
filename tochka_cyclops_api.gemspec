# frozen_string_literal: true

require_relative "lib/tochka_cyclops_api/version"

Gem::Specification.new do |spec|
  spec.name = "tochka_cyclops_api"
  spec.version = TochkaCyclopsApi::VERSION
  spec.authors = ["andrewgavrick"]
  spec.email = ["andrewgavrick@yandex.ru"]

  spec.summary = "Gem for working with the api of the Tochka bank"
  spec.description = "em for working with the api of the bank Point"
  spec.homepage = "https://gitlab.com/andrewgavrick/tochka_api"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://gitlab.com/andrewgavrick/tochka_api"
  spec.metadata["changelog_uri"] = "https://gitlab.com/andrewgavrick/tochka_api/-/blob/main/CHANGELOG.md?ref_type=heads"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)

  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-validation", "~> 1.10"
  spec.add_dependency "dry-struct", "~> 1.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
