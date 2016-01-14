class Importer
  def process(data)
    return true if data.empty?

    rows = data.split("\n")
    entries = rows.split('')

    entries.each do |entry|
      case
      when entry.any? {|row| row =~ /AERODROME HOURS OF OPS\/SERVICE/ }
        OpeningTime.build(entry)
      end
    end

    true
  rescue => e
    @errors = e.message
    false
  end

  def errors
    @errors
  end
end
