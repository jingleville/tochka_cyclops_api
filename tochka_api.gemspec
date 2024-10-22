Gem::Specification.new do |s|
  s.name        = "tochka_api"
  s.version     = "0.0.0"
  s.summary     = "TochkaApi"
  s.description = "This is a gem for bank 'Tochka' api!"
  s.authors     = ["Andrew Gavrick"]
  s.email       = "andrewgavrick@yandex.ru"

  s.add_dependency 'faraday', '~> 2.12'
  s.add_dependency 'dry-validation', '~> 1.7'

  s.files       = [
    "lib/tochka_api.rb",
    "lib/tochka_api/configuration.rb",
    "lib/tochka_api/response.rb",
    "lib/tochka_api/version.rb",
    "lib/tochka_api/api/request.rb",
    "lib/tochka_api/api/schemes/echo.rb"
  ]
  s.homepage    =
    "https://rubygems.org/gems/tochka_api"
  s.license     = "MIT"
end


