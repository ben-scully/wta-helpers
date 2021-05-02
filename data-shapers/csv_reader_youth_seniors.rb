#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'json'
require 'byebug'

class String
  def snakecase
    #gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr('-', '_').
      gsub(/\s/, '_').
      gsub(/__+/, '_').
      downcase
  end
end

grade = "YouthSenior"
base_file_path = '/Users/scully/Downloads'
csv = CSV.read("#{base_file_path}/2020_21 WTA Player Payments - XeroInv#{grade}.csv")

headers = csv.shift

csv_as_hash = csv.map do |row|
  row.map.with_index.each_with_object({}) do |(col, idx), obj|
    header = headers[idx].snakecase
    obj[header] = col
    obj
  end
end

def contact(first_name, last_name, email)
  {
    "Name": "#{first_name} #{last_name}",
    "FirstName": first_name,
    "LastName": last_name,
    "EmailAddress": email
  }
end

def invoice(contact_id, date, due_date, ref, desc, unit_amount, acnt_code)
  {
    "Type": 'ACCREC',
    "Contact": {
      "ContactID": contact_id
    },
    "DateString": "#{date}T00:00:00",
    "DueDateString": "#{due_date}T00:00:00",
    "LineAmountTypes": 'Inclusive',
    "Reference": ref,
    "LineItems": [
      {
        "Description": desc,
        "Quantity": "1",
        "UnitAmount": unit_amount,
        "AccountCode": acnt_code
      }
    ]
  }
end

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

  File.open("secrets/contacts-to-create-#{grade.downcase}.json", 'w') do |file|
    file.puts json.to_json
  end
end

unless invoices.empty?
  json = {
    Invoices: invoices
  }

  puts json.to_json

  File.open("secrets/invoices-to-create-#{grade.downcase}.json", 'w') do |file|
    file.puts json.to_json
  end
end
