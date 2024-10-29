responses = Dir['./schemas/responses/*']
requests = Dir['./schemas/requests/*']

class String
  def snake_to_camel
    self.split('_').map(&:capitalize).join
  end

  def snake_to_kebab
    self.split('_').join('-')
  end

  def camel_to_snake
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

  def cebab_to_snake
    self.split('-').join('_')
  end
end


responses.each do |x|
  file = File.read(x)
  classes = file.scan(/class (.*)/).flatten.map{ |cla| cla.split(' ')[0]}
  file_based_class = x.split('/')[-1].gsub('.rb','').snake_to_camel

  unless classes.include? file_based_class
    puts x
  end
end

requests.each do |x|
  file = File.read(x)
  classes = file.scan(/class (.*)/).flatten.map{ |cla| cla.split(' ')[0]}
  file_based_class = x.split('/')[-1].gsub('.rb','').snake_to_camel

  unless classes.include? file_based_class
    puts x
  end
end

methods = %w[
  create_beneficiary_ul
  create_beneficiary_ip
  create_beneficiary_fl
  update_beneficiary_ul
  update_beneficiary_ip
  update_beneficiary_fl
  list_beneficiary
  get_beneficiary
  deactivate_beneficiary
  activate_beneficiary
  create_virtual_account
  list_virtual_account
  get_virtual_account
  list_virtual_transaction
  refund_virtual_account
  transfer_between_virtual_accounts
  transfer_between_virtual_accounts_v2
  get_virtual_accounts_transfer
  list_payments
  list_payments_v2
  get_payment
  identification_payment
  identification_returned_payment_by_deal
  refund_payment
  compliance_check_payment
  payment_of_taxes
  generate_payment_order
  create_deal
  update_deal
  list_deals
  get_deal
  execute_deal
  rejected_deal
  cancel_deal_with_executed_recipients
  compliance_check_deal
  list_documents
  get_document
  list_bank_sbp
  generate_sbp_qrcode
]

def request_base(snake_case)
[
"# frozen_string_literal: true",
"",
"require 'dry-validation'",
"",
"module TochkaCyclopsApi",
"  module Schemas",
"    module Requests",
"      # https://api.tochka.com/static/v1/tender-docs/cyclops/main/api_v2.html#api-v2-#{snake_case.snake_to_kebab}",
"      class #{snake_case.snake_to_camel} < Dry::Validation::Contract",
"        schema do",
"        end",
"      end",
"    end",
"  end",
"end"
].join("\n")
end


def response_base(snake_case)
[
"# frozen_string_literal: true",
"",
"require 'dry-struct'",
"",
"module TochkaCyclopsApi",
"  module Schemas",
"    module Responses",
"      # Response chema for #{snake_case} request",
"      class #{snake_case.snake_to_camel} < Dry::Struct",
"      end",
"    end",
"  end",
"end"].join("\n")
end

methods.each do |method|
  request_path = "./schemas/requests/#{method}.rb"
  response_path = "./schemas/responses/#{method}.rb"
  unless File.exists?(request_path)
    File.open("out.txt", 'w') do |f|
      f.write(request_base method)
    end
  end

  unless File.exists?(response_path)
    File.open("out.txt", 'w') do |f|
      f.write(response_base method)
    end
  end
end
