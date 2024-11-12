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

- [ ] Realize request resend logic
- [ ] Add document sending logic
- [ ] Add API schemas
  - [X] Beneficiaries
    - [X] [CreateBeneficicaryUl](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-ul)
    - [X] [CreateBeneficicaryIp](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-ip)
    - [X] [CreateBeneficicaryFl](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-beneficiary-fl)
    - [X] [UpdateBeneficicaryUl](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-update-beneficiary-ul)
    - [X] [UpdateBeneficicaryIp](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-update-beneficiary-ip)
    - [X] [UpdateBeneficicaryFl](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-update-beneficiary-fl)
    - [X] [ListBeneficiary](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-list-beneficiary)
    - [X] [GetBeneficiary](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-get-beneficiary)
    - [X] [DeactivateBeneficicary](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-deactivate-beneficiary)
    - [X] [ActivateBeneficiary](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-activate-beneficiary)
  - [ ] Virtual accounts
    - [ ] [CreateVirtualAccount](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#create-virtual-account)
    - [ ] [ListVirtualAccount](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#list-virtual-account)
    - [ ] [GetVirtualAccount](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#get-virtual-account)
    - [ ] [ListVirtualTransaction](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-list-virtual-transaction)
    - [ ] [RefundVirtuaAccount](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-refund-virtual-account)
    - [ ] [TransferBetweenVirtualAccounts](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-transfer-between-virtual-accounts)
    - [ ] [TransferBetweenVirtualAccountsV2](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#v2)
    - [ ] [GetVirtualAccountTransfer](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-get-virtual-accounts-transfer)
  - [ ] Payments
    - [ ] [ListPayments](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-list-payments)
    - [ ] [ListPaymentsV2](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-list-payments-v2)
    - [ ] [GetPayment](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-get-payment)
    - [ ] [IdentificationPayment](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#identification-payment)
    - [ ] [IdentificationReturnedPaymentByDeal](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-identification-returned-payment-by-deal)
    - [ ] [RefundPayment](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-refund-payment)
    - [ ] [CompilanceCheckPayment](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#compliance-check-payment)
    - [ ] [PaymentOfTaxes](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#payment-of-taxes)
    - [ ] [PDF](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#pdf)
  - [ ] Deals
    - [ ] [CreateDeal](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-create-deal)
    - [ ] [UpdateDeal](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-update-deal)
    - [ ] [ListDeals](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-list-deals)
    - [ ] [GetDeal](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-get-deal)
    - [ ] [ExecuteDeal](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-execute-deal)
    - [ ] [RejectedDeal](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-rejected-deal)
    - [ ] [CancelDealWithExecutedRecipients](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#cancel-deal-with-executed-recipients)
  - [ ] Documents
    - [ ] [ListDocuments](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-list-documents)
    - [ ] [GetDocument](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-get-document)
  - [ ] Quick payment system
    - [ ] [SBPListBankSBP](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-sbp-list-bank-sbp)
    - [ ] [QRC2B](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#qr-c2b)
  - [ ] Documents upload
    - [ ] [UploadDocumentBeneficiary](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#upload-document-beneficiary)
    - [ ] [UploadDocumentDeal](https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#upload-document-deal)
- [ ] Add tests
- [ ] Add styleguide
- [ ] Refactor rake tasks

## Acknowledgements

Special thanks for support in development to [unurgunite][unurgunite] and [o-200][o-200]

[api_source_page]: https://api.tochka.com/static/v1/tender-docs/cyclops/main/index.html
[unurgunite]: https://github.com/unurgunite
[o-200]: https://github.com/o-200