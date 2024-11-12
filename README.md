# TochkaCyclopsApi

A simple way to interact with the ["Tochka" bank's api][api_source_page]

## Table of Contents

- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Settings](#settings)
- [Usage](#usage)
  - [Rake tasks](#rake)
- [TODO](#todo)
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
## TODO

- [x] Update `README.md`
- [ ] Refactor code base
- [ ] Realize request resend logic
- [ ] Add API schemas
- - [ ] Beneficiaries
- - - [ ] [CreateBeneficicaryUl](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-ul)
- - - [ ] [CreateBeneficicaryIp](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-ip)
- - - [ ] [CreateBeneficicaryFl](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-fl)
- - - [ ] [UpdateBeneficicaryUl](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-update-beneficiary-ul)
- - - [ ] [UpdateBeneficicaryIp](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-update-beneficiary-ip)
- - - [ ] [UpdateBeneficicaryFl](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-update-beneficiary-fl)
- - - [ ] [ListBeneficiary](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-list-beneficiary)
- - - [ ] [GetBeneficiary](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-get_beneficiary)
- - - [ ] [DeactivateBeneficicary](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-deactivate-beneficiary)
- - - [ ] [ActivateBeneficiary](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-activate-beneficiary)
- - [ ] Virtual accounts
- - [ ] Payments
- - [ ] Deals
- - [ ] Documents
- - [ ] Quick payment system
- - [ ] Documents upload
- [ ] Add tests with RSpec
- [ ] 100% code coverage with RuboCop
- [ ] Refactor code according to the style guides

<li class="toctree-l2"><a class="reference internal" href="#id14">Виртуальные счета</a><ul>
<li class="toctree-l3"><a class="reference internal" href="#create-virtual-account">Создание виртуального счёта</a></li>
<li class="toctree-l3"><a class="reference internal" href="#list-virtual-account">Список виртуальных счетов</a></li>
<li class="toctree-l3"><a class="reference internal" href="#get-virtual-account">Информация по виртуальному счёту</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-list-virtual-transaction">Отобразить виртуальные операции по виртуальному счёту</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-refund-virtual-account">Вывод денег с виртуального счёта</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-transfer-between-virtual-accounts">Переводы между виртуальными счетами</a></li>
<li class="toctree-l3"><a class="reference internal" href="#v2">Перевод денег между виртуальными счетами (v2)</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-get-virtual-accounts-transfer">Получить информацию по переводу между виртуальными счетами</a></li>


<li class="toctree-l2"><a class="reference internal" href="#id22">Платежи</a><ul>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-list-payments">Список платежей</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-list-payments-v2">Список платежей (v2)</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-get-payment">Информация по платежу</a></li>
<li class="toctree-l3"><a class="reference internal" href="#identification-payment">Идентификация платежей</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-identification-returned-payment-by-deal">Идентификация возвращенного платежа по сделке</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-refund-payment">Возврат платежей</a></li>
<li class="toctree-l3"><a class="reference internal" href="#compliance-check-payment">Проверка платежа на возможность проведения</a></li>
<li class="toctree-l3"><a class="reference internal" href="#payment-of-taxes">Выплата налогов исполнителю</a></li>
<li class="toctree-l3"><a class="reference internal" href="#pdf">Генерация платежного поручения в PDF формате</a></li>


<li class="toctree-l2"><a class="reference internal" href="#api-v2-deal">Сделки</a><ul>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-create-deal">Создание сделки</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-update-deal">Обновление сделки</a></li>
<li class="toctree-l3"><a class="reference internal" href="#deprecated">Список сделок (deprecated)</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-list-deals">Список сделок новая</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-get-deal">Информация по сделке</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-execute-deal">Исполнение сделки</a></li>
<li class="toctree-l3"><a class="reference internal" href="#api-v2-rejected-deal">Отмена сделки</a></li>
<li class="toctree-l3"><a class="reference internal" href="#cancel-deal-with-executed-recipients">Отмена сделки из коррекции с одним плательщиком</a></li>


## Acknowledgements

Special thanks for support in development to [unurgunite][unurgunite] and [o-200][o-200]

[api_source_page]: https://api.tochka.com/static/v1/tender-docs/cyclops/main/index.html
[unurgunite]: https://github.com/unurgunite
[o-200]: https://github.com/o-200