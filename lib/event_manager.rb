require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

puts 'Event Manager Initiliazed!'

class EventManager # rubocop:disable Style/Documentation
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

  def create_letter(id, form_letter)
    Dir.mkdir('legislators', 777) unless Dir.exist?('legislators')

    file_name = "legislators/#{id}.html"

    File.open(file_name, 'w') { |f| f.puts(form_letter) }
  end

  def contents
    return unless File.exist? 'event_attendees.csv'

    CSV.open(
      'event_attendees.csv',
      headers: true,
      header_converters: :symbol
    )
  end

  def generate_letters
    template_letter = File.read('form_letter.erb')
    erb_template = ERB.new template_letter

    contents.each do |row|
      id = row[0]
      name = row[:first_name].capitalize
      zipcode = handle_zipcode(row[:zipcode])
      legislators = legislators_by_zipcode(zipcode)

      form_letter = erb_template.result(binding)

      create_letter(id, form_letter)
    end
  end
end

event = EventManager.new
event.generate_letters
