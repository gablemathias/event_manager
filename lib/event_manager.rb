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
  if zipcode.nil?
    '00000'
  elsif zipcode.size < 5
    zipcode.rjust(5, '0')
  elsif zipcode.size > 5
    zipcode.slice(...5)
  else
    zipcode
  end
end

contents.each do |row|
  name = row[:first_name]
  zipcode = handle_zipcode(row[:zipcode])

  puts "#{name} - #{zipcode}"
end
