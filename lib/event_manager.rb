require 'csv'
require 'google/apis/civicinfo_v2'

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = File.read('secret.key').strip

puts 'Event Manager Initiliazed!'

def handle_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')
end

if File.exist? 'event_attendees.csv'
  contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
  )
end

contents.each do |row|
  name = row[:first_name]
  zipcode = handle_zipcode(row[:zipcode])

  begin
    legislators = civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    )

    legislators = legislators.officials
    legislator_name = legislators.map(&:name).join(', ')
  rescue StandardError
    legislator_name = 'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials' # rubocop:disable Layout/LineLength
  end

  puts "#{name} - #{zipcode} - #{legislator_name}"
end
