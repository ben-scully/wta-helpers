#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'json'
require 'byebug'

# INJECT
grade = ENV['GRADE']

base_file_path = "#{ENV['HOME']}/Downloads"
payment_file_name = "#{base_file_path}/2020_21 WTA Player Payments - InvoiceOverdues.csv"

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
  "secrets/contacts_to_create_#{grade.snakecase}.json",
  'Contacts',
  contacts
)
