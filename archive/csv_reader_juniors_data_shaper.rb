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

grade = 'Juniors'
base_file_path = '/Users/scully/Downloads'
payment_file_name = "#{base_file_path}/2020_21 WTA Player Payments - XeroInv#{grade}.csv"
reference_file_name = "#{base_file_path}/WTA-Junior-Extender-Series-Raw-Data - reference.csv"
output_file_name = "#{base_file_path}/wiggle.csv"

payment_headers, payments_as_hash = csv_as_hash(payment_file_name)
# puts payments_as_hash

reference_headers, reference_as_hash = csv_as_hash(reference_file_name)
# puts reference_as_hash

matches = []
mismatches = []

payments_as_hash.map do |payment|
  p_compare = payment['child_first'].snakecase + payment['child_last'].snakecase

  # byebug if dbl_checks.include?(payment['child_first'].snakecase)

  result = reference_as_hash.find do |ref|
    r_compare = ref['child_first'].snakecase + ref['child_last'].snakecase

    # byebug if dbl_checks.include?(ref['child_first'].snakecase)

    p_compare == r_compare
  end

  if result
    payment['caregiver_name'] = result['caregiver_name']
    payment['caregiver_email'] = result['caregiver_email']
    matches << payment
  else
    mismatches << p_compare
  end
end

puts matches
puts "--------------------"
puts mismatches

CSV.open(output_file_name, "wb") do |csv|
  csv << payment_headers + reference_headers

  matches.each do |row|
    csv << row.values
  end
end
