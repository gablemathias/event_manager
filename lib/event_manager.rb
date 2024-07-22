require 'csv'
require 'google/apis/civicinfo_v2'

puts 'Event Manager Initiliazed!'

def handle_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')
end

def legislators_by_zipcode(zipcode) # rubocop:disable Metrics/MethodLength
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = File.read('secret.key').strip

  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    )

    legislators = legislators.officials
    legislators.map(&:name).join(', ')
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

if File.exist? 'event_attendees.csv'
  contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
  )
end

contents.each do |row|
  name = row[:first_name].capitalize
  zipcode = handle_zipcode(row[:zipcode])
  legislator = legislators_by_zipcode(zipcode)

  puts "#{name} - #{zipcode} - #{legislator}"
end
