require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

puts 'Event Manager Initiliazed!'

def handle_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0...5]
end

def legislators_by_zipcode(zipcode) # rubocop:disable Metrics/MethodLength
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = File.read('secret.key').strip

  begin
    civic_info.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
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

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  Dir.mkdir('legislators', 777) unless Dir.exist?('legislators')

  id = row[0]
  name = row[:first_name].capitalize
  zipcode = handle_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)
  file_name = "legislators/#{id}.html"

  File.open(file_name, 'w') { |f| f.puts(form_letter) }
end
