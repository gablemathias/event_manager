require 'csv'
require 'time'

def contents
  return unless File.exist? 'event_attendees.csv'

  CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
  )
end

# Find the peak registration date

time_content = contents.map do |row|
  Time.strptime(row[:regdate], '%m/%d/%y %H:%M')
end

hours = time_content.map do |t|
  if t.min >= 45
    t.hour + 1
  else
    t.hour
  end
end

hour_occurrence = {}
hours.each do |h|
  if hour_occurrence.key?(h)
    hour_occurrence[h] += 1
  else
    hour_occurrence[h] = 1
  end
end

max_occurrence = hour_occurrence.values.max

p hour_occurrence.filter { |_, v| v == max_occurrence }.keys
