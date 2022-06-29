# frozen_string_literal: true

require 'csv'
require 'json'
require 'byebug'

CLIENT_ID = '36A8C24BC45C47A5A2E53B111BE64D7B'
TENANT_ID = '0396ad9d-7fae-4687-a743-014e30a3edf1'

class String
  def snakecase
    #gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .tr('-', '_')
      .gsub(/\s/, '_')
      .gsub(/__+/, '_')
      .downcase
  end
end

def csv_as_hash(filename, required_headers)
  csv = CSV.read(filename)
  headers = csv.shift
  headers = headers&.map(&:snakecase)

  missing = required_headers - headers
  unless missing.empty?
    raise <<~HEREDOC
      \n
      these headers are missing: #{missing}

      from required_headers:     #{required_headers}
    HEREDOC
  end

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

def create_contact(contact)
  file = File.read("secrets/oauth2-token.json")
  data_hash = JSON.parse(file)
  access_token = data_hash['access_token']

  # new_contacts_list=$(curl -v -POST \
  #   --url "https://api.xero.com/api.xro/2.0/Contacts?summarizeErrors=false" \
  #   -H "Content-Type: application/json" \
  #   -H "Accept: application/json" \
  #   -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  #   -H "Xero-tenant-id: ${TENANT_ID}" \
  #   -d "${NEW_CONTACTS}")

  require 'uri'
  require 'net/http'

  uri = URI('https://api.xero.com/api.xro/2.0/Contacts?summarizeErrors=false')
  headers = {
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'Authorization' => "Bearer #{access_token}",
    'Xero-tenant-id': TENANT_ID.to_s
  }
  payload = {
    Contacts: [contact]
  }



  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.post(uri, payload.to_json, headers)

  puts "response.code:"
  puts response.code
  puts

  if response.is_a?(Net::HTTPSuccess)
    puts "JSON.parse(response.body):"
    result = JSON.parse(response.body)
    puts result
    puts
  end

  byebug
end

def store_contacts_for_creation(contacts, suffix)
  raise "missing suffix" unless suffix

  return if contacts.empty?

  json = {
    Contacts: contacts
  }

  puts json.to_json

  File.open("secrets/contacts_to_create_#{suffix}.json", 'w') do |file|
    file.puts json.to_json
  end
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
