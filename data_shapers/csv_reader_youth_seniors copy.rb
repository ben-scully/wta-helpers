#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'json'
require 'byebug'

grade = "YouthSenior"
base_file_path = '/Users/scully/Downloads'
filename = "#{base_file_path}/2020_21 WTA Player Payments - XeroInv#{grade}.csv"


contacts = []
invoices = []

csv_as_hash.each do |line|
  if line['xero_name'] == "NEW"
    first_name = line['xero_first_name']
    last_name = line['xero_last_name']
    email = line['xero_email']
    contacts << contact(first_name, last_name, email)
  end

  contact_id = line['xero_contact_id']
  date = Date.parse(line['date']).to_s
  due_date = Date.parse(line['due_date']).to_s
  reference = "#{line['player_name']} #{line['team']} #{line['description']}"
  description = reference
  unit_amount = line['unit_amount']
  acnt_code = line['account_code']

  invoices << invoice(
    contact_id,
    date,
    due_date,
    reference,
    description,
    unit_amount,
    acnt_code
  )
end

unless contacts.empty?
  json = {
    Contacts: contacts
  }

  puts json.to_json

  File.open("secrets/contacts_to_create_#{grade.downcase}.json", 'w') do |file|
    file.puts json.to_json
  end
end

unless invoices.empty?
  json = {
    Invoices: invoices
  }

  puts json.to_json

  File.open("secrets/invoices_to_create_#{grade.downcase}.json", 'w') do |file|
    file.puts json.to_json
  end
end
