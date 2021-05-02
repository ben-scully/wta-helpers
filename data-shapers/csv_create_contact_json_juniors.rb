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

def csv_as_hash(filename)
  csv = CSV.read(filename)
  headers = csv.shift
  headers = headers&.map(&:snakecase)
  puts headers

  rows = csv.map do |row|
    row.map.with_index.each_with_object({}) do |(col, idx), obj|
      header = headers[idx]
      obj[header] = col
      obj
    end
  end

  [headers, rows]
end

def store_in_file(filename, main_key, records)
  return if records.empty?

  hash = {
    "#{main_key}": records
  }

  puts hash.to_json

  File.open(filename, 'w') do |file|
    file.puts hash.to_json
  end
end

grade = 'Juniors'
base_file_path = '/Users/scully/Downloads'
payment_file_name = "#{base_file_path}/2020_21 WTA Player Payments - XeroInv#{grade}.csv"

_payment_headers, payments_as_hash = csv_as_hash(payment_file_name)

def contact(first_name, last_name, email)
  {
    "Name": "#{first_name} #{last_name}".strip,
    "FirstName": first_name,
    "LastName": last_name,
    "EmailAddress": email
  }
end

contacts = payments_as_hash.map do |row|
  next unless row['xero_contact_id'].nil?

  first_name, last_name = row['xero_name']&.split(' ', 2)
  email = row['xero_email']
  contact(first_name, last_name, email)
end

store_in_file(
  "secrets/contacts-to-create-#{grade.snakecase}.json",
  'Contacts',
  contacts
)
