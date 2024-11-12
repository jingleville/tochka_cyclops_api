# TochkaCyclopsApi

A simple way to interact with the ["Tochka" bank's api][api_source_page]

## Table of Contents

- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Settings](#settings)
- [Usage](#usage)
  - [Rake tasks](#rake)
- [Acknoledgements](#acknowledgements)

## Getting started

### Installation

Add this line to your application's Gemfile:

```sh
bundle add tochka_cyclops_api
```

and run commands bellow to create models, migrations and the initializer:

```sh
rails generate tochka_cyclops_api:models
rails generate tochka_cyclops_api:initializer
```

to use rake tasks you should also add the following lines to Rakefile of your Rails project:

```ruby
spec = Gem::Specification.find_by_name 'tochka_cyclops_api'
load "#{spec.gem_dir}/lib/tasks/methods.rake"
```

### Settings

You have to set the settings in the initializer file (_config/initializers/tochka_cyclops_api.rb_):

```ruby
# frozen_string_literal: true

TochkaCyclopsApi.configure do |config|
  config.certificate = File.read(PATH TO TOCHKA CERTIFICATE)
  config.private_key = File.read(PATH TO TOCHKA PRIVATE KEY)
  config.sign_thumbprint = YOUR THUMBPRINT
  config.sign_system = YOUR SYSTEM
end
```

## Usage

To send a request use the following command:
```ruby
TochkaCyclopsApi.send_request(method, data)
```
method - name of the method defined on the bank side point;
data - hash of the value required to fulfill the request.

There are special rake tasks to get information about available methods:

```sh
bundle exec rake methods:list
bundle exec rake methods:desc method=method_name
```

Examples
```sh
> bundle exec rake methods:list
# ** Invoke methods:list (first_time)
# ** Execute methods:list
# echo
# create_beneficiary_ul
# create_beneficiary_ip
# ...

> bundle exec rake methods:desc method=create_beneficiary_ul
# ** Invoke methods:desc (first_time)
# ** Execute methods:desc
# inn                  | mandatory | string
# nominal_account_code | optional  | string
# nominal_account_bic  | optional  | string
# beneficiary_data     | mandatory | {
#                                       name | mandatory | string
#                                       kpp  | mandatory | string
#                                       ogrn | optional  | string
#                                    }
#
# ================================================================================
#
# EXAMPLE
#
# {
#   inn: '7743745038',
#   nominal_account_code: '40702810338170022645',
#   nominal_account_bic: '044525225',
#   beneficiary_data: {
#     name: 'ООО «ТК ИнжСтройКомплект»',
#     kpp: '773401001',
#     ogrn: '1097746324169'
#   }
# }
```

Example of sending request:
```ruby
TochkaCyclopsApi.send_request(
  # Method contains the name of the TochkaCyclopsApi method
  method: 'create_beneficiary_ul',
  # Data is value for the "params" field of request body
  data: {
    inn: "7925930371",
    nominal_account_code: "000000000000000000000",
    nominal_account_bic: "0000000000",
    beneficiary_data: {
        name: "ООО \"Рога и Копыта\"",
        kpp: "246301001"
    }
  },
  # Layer have to has one of the following values: :stage, :pre, :prod
  layer: :stage
)
```

## Acknowledgements

Special thanks for support in development to [unurgunite][unurgunite] and [o-200][o-200]

[api_source_page]: https://api.tochka.com/static/v1/tender-docs/cyclops/main/index.html
[unurgunite]: https://github.com/unurgunite
[o-200]: https://github.com/o-200