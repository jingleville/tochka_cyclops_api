# [Rails::Healthcheck][gem_page]

[![Gem Version][gem_version_image]][gem_version_page]

A simple way to configure a healthcheck route in Rails applications

## Table of Contents

- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Settings](#settings)
  - [Custom Response](#custom-response)
  - [Verbose](#verbose)
  - [Ignoring logs](#ignoring-logs)
    - [Lograge](#lograge)
    - [Datadog](#datadog)
  - [Requests Examples](#requests-examples)
- [Contributing](#contributing)
- [License](#license)

## Getting started

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'tochka_cylops_api'
```

and run commands bellow to create the initializer:

```
rails generate tochka_cylops_api:install
rails generate tochka_cylops_api:model
```

### Settings

You have to set the settings in the initializer file (_config/initializers/healthcheck.rb_):

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

For example:
```ruby
TochkaCyclopsApi.send(
  inicialize_beneficiary_ul,
  {
    inn: "7925930371",
    nominal_account_code: "000000000000000000000",
    nominal_account_bic: "0000000000",
    beneficiary_data: {
        name: "ООО \"Рога и Копыта\"",
        kpp: "246301001"
    }
  }
)
```
