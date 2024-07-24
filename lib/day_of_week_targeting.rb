require 'csv'
require 'time'

DAYS_OF_THE_WEEK = %w[Sunday Monday Tuesday Wednesday Thursday Saturday Sunday].freeze

def contents
  return unless File.exist? 'event_attendees.csv'

  CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
  )
end

time_content = contents.map do |row|
  Time.strptime(row[:regdate], '%m/%d/%y %H:%M')
end

days = time_content.map(&:wday)

day_occurrence = {}
days.each do |h|
  if day_occurrence.key?(h)
    day_occurrence[h] += 1
  else
    day_occurrence[h] = 1
  end
end

max_occurrence = day_occurrence.values.max

p(day_occurrence.filter { |_, v| v == max_occurrence }.keys.map { |day| DAYS_OF_THE_WEEK[day] }.join(', '))
