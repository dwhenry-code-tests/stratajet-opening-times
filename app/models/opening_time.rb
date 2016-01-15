class OpeningTime < ActiveRecord::Base
  # This lookup works on the basis that MON will always be present in the opening time
  # i.e. SUN-TUE is not valid.
  PREVIOUS_DAY = {
    'TUE' => 'MON',
    'WED' => 'TUE',
    'THU' => 'WED',
    'FRI' => 'THU',
    'SAT' => 'FRI',
    'SUN' => 'SAT',
  }

  # don't like hard coding different ways of writting closed.
  TIME_MAP = {
    'CLOSED' => 'CLOSED',
    'CLSD' => 'CLOSED',
  }

  class << self
    # This code could potentially be extracted to a builder class
    def build(data)
      row = data.detect { |e| e =~ /A\)/ }
      icao = row.match(/A\)\s+(\w+)/)[1]

      opening_time = OpeningTime.find_or_create_by(icao: icao)
      opening_time.update_attributes(opening_times(data))
    end

    def opening_times(data)
      e_row = data.detect { |e| e =~ /E\)/ }
      e_index = data.index(e_row)
      time_data = data[e_index..-3].join(' ')

      {
        monday: extract(time_data, 'MON'),
        tuesday: extract(time_data, 'TUE'),
        wednesday: extract(time_data, 'WED'),
        thursday: extract(time_data, 'THU'),
        friday: extract(time_data, 'FRI'),
        saturday: extract(time_data, 'SAT'),
        sunday: extract(time_data, 'SUN'),
        raw: time_data,
      }
    end

    def extract(time_data, day, range_required: false)
      raise "Unable to find data within: #{time_data}" if day.nil?

      # extract time data or the word CLOSED for the given day
      match = time_data.match(/#{day}(?:-\w{3})#{'?' unless range_required}\s*([0-9\-\s]+|#{TIME_MAP.keys.join('|')})/)

      if match
        time = match[1].strip
        TIME_MAP[time] || time
      else
        extract(time_data, PREVIOUS_DAY[day], range_required: true)
      end
    end
  end
end
