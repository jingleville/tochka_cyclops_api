# TochkaCyclopsApi

Гем для работы с API банка Точка
https://api.tochka.com/static/v1/tender-docs/cyclops/main/requests.html

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add tochka_cyclops_api
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install tochka_cyclops_api
```

Current gem version works only with rails projects.

## Usage

Перед тем, как приступить к использованию требуется подготовить гем.
1) для генерации используемых моделей и таблиц запустите команду

  ```
  rails g tochka_cyclops_api:model
  ```

  После успешного выполнения запустите миграцию
  ```
  rails db:migrate
  ```

  При этом будут созданы 3 таблицы и модели связанные с ними.
  - tochka_cyclops_requests
  - tochka_cyclops_responses
  - tochka_cyclops_errors

2) после необходимо сгенерировать в директории config файл конфигурации
  # tochka_cyclops_api.rb
  ```
  TochkaCyclopsApi.configure do |config|
    config.certificate = File.read(ENV['TOCHKA_CERTIFICATE'])
    config.private_key = File.read(ENV['TOCHKA_PRIVATE_KEY'])
    config.sign_thumbprint = 'da10812df4559645b7bc3fe7a02229fc63c30d7e'
    config.sign_system = 'birdsbuild'
  end
  ```

После того как данные действия выполнены можно приступать к использованию гема.
Для отправки запроса используется команда:
```
TochkaCyclopsApi.send_request(method, data)
```
method - наименование метода, определенное на стороне банка точка;
data - хэш значение, требуемых для осуществления запроса.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andrewgavrick/tochka_cyclops_api.
