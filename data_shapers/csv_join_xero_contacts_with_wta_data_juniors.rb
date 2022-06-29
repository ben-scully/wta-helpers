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

  rows = csv.map do |row|
    row.map.with_index.each_with_object({}) do |(col, idx), obj|
      header = headers[idx]
      obj[header] = col
      obj
    end
  end

  [headers, rows]
end

def xero_contact_list
  base_file_path = '/Users/scully/Projects/'
  filename = "#{base_file_path}wta-helpers/secrets/contacts_list.json"
  xero_raw = File.read(filename)
  JSON.parse(xero_raw)
end

grade = 'Juniors'
base_file_path = '/Users/scully/Downloads/'
payment_file_name = "#{base_file_path}2020_21 WTA Player Payments - XeroInv#{grade}.csv"
output_file_name = "#{base_file_path}/jiggle.csv"

payment_headers, payments_as_hash = csv_as_hash(payment_file_name)
xero_contact_as_hash = xero_contact_list['Contacts']

matches = []
mismatches = []

payments_as_hash.map do |payment|
  p_compare = payment['xero_email']

  result = xero_contact_as_hash.find do |xero_contact|
    x_compare = xero_contact['EmailAddress']

    p_compare == x_compare
  end

  if result
    payment['xero_contact_id'] = result['ContactID']
    matches << payment
  else
    mismatches << payment
  end
end

puts matches
puts '--------------------'
puts mismatches

CSV.open(output_file_name, 'wb') do |csv|
  csv << payment_headers

  matches.each do |row|
    csv << row.values
  end
end
