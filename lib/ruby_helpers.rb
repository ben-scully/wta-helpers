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

def store_in_file(filename, main_key, records)
  return if records.empty?

  hash = {
    "#{main_key}": records
  }

  File.open(filename, 'w') do |file|
    file.puts hash.to_json
  end
end

def contact(first_name, last_name, email)
  {
    "Name": "#{first_name} #{last_name}".strip,
    "FirstName": first_name,
    "LastName": last_name,
    "EmailAddress": email
  }
end

def invoice(contact_id, date, due_date, ref, line_items)
  items = line_items.map do |item|
    {
      "Description": item[:description],
      "Quantity": item[:quantity] || '1',
      "UnitAmount": item[:unit_amount],
      "AccountCode": item[:account_code]
    }
  end

  {
    "Type": 'ACCREC',
    "Contact": {
      "ContactID": contact_id
    },
    "DateString": "#{date}T00:00:00",
    "DueDateString": "#{due_date}T00:00:00",
    "LineAmountTypes": 'Inclusive',
    "Reference": ref,
    "LineItems": items
  }
end
