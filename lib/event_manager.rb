require 'csv'

puts 'Event Manager Initiliazed!'

if File.exist? 'event_attendees.csv'
  contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
  )
end

def handle_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')
end

contents.each do |row|
  name = row[:first_name]
  zipcode = handle_zipcode(row[:zipcode])

  puts "#{name} - #{zipcode}"
end
