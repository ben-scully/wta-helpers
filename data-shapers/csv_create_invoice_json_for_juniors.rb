#!/usr/bin/env ruby
# frozen_string_literal: true

require './lib/ruby_helpers.rb'

grade = 'Juniors'
base_file_path = '/Users/scully/Downloads/'
payment_file_name = "#{base_file_path}2020_21 WTA Player Payments - XeroInv#{grade}.csv"

_payment_headers, payments_as_hash = csv_as_hash(payment_file_name)

invoices = payments_as_hash.map do |payment|
  contact_id = payment['xero_contact_id']
  date = '2020-12-31'
  due_date = '2020-12-31'
  player_name = "#{payment['child_first']} #{payment['child_last']}"
  reference = "2020-21 Junior Season fees for #{player_name}"

  ex_tender =
    if payment['type'] == 'Individual'
      'ExTender series (Individual) = $60.00'
    else
      'ExTender series (Family) = $50.00'
    end
  whanganui = payment['whanganui'].to_i.positive? ? 'Whanganui touch tournament = $15.00' : nil
  palmerston = payment['palmerston'].to_i.positive? ? 'Palmerston Noth touch tournament = $20.00' : nil
  total = '%.2f' % (payment['ex_tender'].to_i + payment['whanganui'].to_i + payment['palmerston'].to_i)
  payments_made = '%.2f' % payment['payment_totals']
  still_to_pay = '%.2f' % payment['difference']

  raw = [
    "#{player_name} fees:",
    ex_tender ? " * #{ex_tender}" : nil,
    whanganui ? " * #{whanganui}" : nil,
    palmerston ? " * #{palmerston}" : nil,
    "Sub-total: $#{total}",
    "Less payments made: $#{payments_made}",
    "Still to pay: $#{still_to_pay}"
  ]
  description = raw.compact.join("\n")

  list_item =
    {
      description: description,
      unit_amount: still_to_pay,
      account_code: '216' # code for 'Juniors - Income'
    }

  invoice(
    contact_id,
    date,
    due_date,
    reference,
    [list_item]
  )
end

puts invoices

store_in_file(
  "secrets/invoices-to-create-#{grade.snakecase}.json",
  'Invoices',
  invoices
)
