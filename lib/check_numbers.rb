require 'csv'

def validate_number(phone_number)
  phone_number = phone_number.to_s.delete('^0-9')
  phone_length = phone_number.length
  return phone_number if phone_length == 10
  return phone_number.slice(1..) if phone_length == 11 && phone_length[0] == 1

  'bad number'
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  puts validate_number(row[:homephone])
end
