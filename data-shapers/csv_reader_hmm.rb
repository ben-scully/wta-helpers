#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'json'
require 'byebug'
require_relative '../lib/ruby_helpers'

tab = 'InvoiceOverdues'
csv_dir = "#{ENV['HOME']}/Downloads"
year = '2021-22'
csv_filename = "#{csv_dir}/#{year} WTA Player Payments - #{tab}.csv"

required_headers = ['player_first', 'player_last', 'payer_first', 'payer_last', 'payer_email', 'payer_xero_contact_id']

_headers, rows = csv_as_hash(csv_filename, required_headers)

contacts = []

rows.each do |row|
  puts "row:"
  puts row
  puts

  if !row['payer_xero_contact_id']
    puts "!row['payer_xero_contact_id']:"
    puts row
    puts

    contact = contact(
      row['payer_first'],
      row['payer_last'],
      row['payer_email'],
    )

    create_contact(contact)
  end
  #   create a contact
  #   and put contact in spreadsheet
  #   and put contact in pseduo spreadsheet

  # if row doesn't have an invoice (invoice_xero_id)
  #   create an invoice
  #   and put invoice in spreadsheet
  #   and put invoice in pseduo spreadsheet
end

puts "contacts"
puts contacts
puts

return
contacts_suffix = Date.today.strftime("%Y-%m-%d")
store_contacts_for_creation(contacts, contacts_suffix)


# invoices = []

# csv_as_hash.each do |line|
#   if line['xero_name'] == "NEW"
#     first_name = line['xero_first_name']
#     last_name = line['xero_last_name']
#     email = line['xero_email']
#     contacts << contact(first_name, last_name, email)
#   end

#   contact_id = line['xero_contact_id']
#   date = Date.parse(line['date']).to_s
#   due_date = Date.parse(line['due_date']).to_s
#   reference = "#{line['player_name']} #{line['team']} #{line['description']}"
#   description = reference
#   unit_amount = line['unit_amount']
#   acnt_code = line['account_code']

#   invoices << invoice(
#     contact_id,
#     date,
#     due_date,
#     reference,
#     description,
#     unit_amount,
#     acnt_code
#   )
# end

# unless contacts.empty?
#   json = {
#     Contacts: contacts
#   }

#   puts json.to_json

#   File.open("secrets/contacts-to-create-#{grade.downcase}.json", 'w') do |file|
#     file.puts json.to_json
#   end
# end

# unless invoices.empty?
#   json = {
#     Invoices: invoices
#   }

#   puts json.to_json

#   File.open("secrets/invoices-to-create-#{grade.downcase}.json", 'w') do |file|
#     file.puts json.to_json
#   end
# end
