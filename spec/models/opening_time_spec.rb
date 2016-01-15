require 'rails_helper'

RSpec.describe OpeningTime, :type => :model do
  describe '.build' do
    context 'with a valid entry record' do
      let(:entry) { [
        'A) ESGJ B) 1502271138 C) 1503012359',
        'E) AERODROME HOURS OF OPS/SERVICE MON-WED 0500-1830 THU 0500-2130',
        'FRI',
        '0730-2100 SAT 0630-0730, 1900-2100 SUN CLOSED'
      ] }

      it 'creates a new record' do
        expect {
          described_class.build(entry)
        }.to change {
          described_class.count
        }.by(1)
      end

      it 'set the icao' do
        described_class.build(entry)
        expect(OpeningTime.first.icao).to eq('ESGJ')
      end

      it 'set the daily opening times' do
        described_class.build(entry)
        opening_time = OpeningTime.first

        expect(opening_time.monday).to eq('0500-1830')
      end

      it 'will update an existing record' do
        opening_time = OpeningTime.create(icao: 'ESGJ', monday: '0900-1700')

        described_class.build(entry)

        opening_time.reload
        expect(opening_time.monday).to eq('0500-1830')
      end
    end
  end

  describe '.extract' do
    it 'can extract when its a single day' do
      expect(described_class.extract('MON 0500-1830', 'MON')).to eq('0500-1830')
    end

    it 'can extract when it the first day in a period' do
      expect(described_class.extract('MON-WED 0500-1830', 'MON')).to eq('0500-1830')
    end

    it 'can extract when it the last day in a period' do
      expect(described_class.extract('MON-WED 0500-1830', 'WED')).to eq('0500-1830')
    end

    it 'can extract multiple times for a period' do
      expect(described_class.extract('MON-WED 0500-1230 1300-1600', 'WED')).to eq('0500-1230 1300-1600')
    end

    it 'spaces are not that important' do
      expect(described_class.extract('MON0500-1830', 'MON')).to eq('0500-1830')
    end

    it 'can extract when it the day is within the period' do
      expect(described_class.extract('MON-WED 0500-1830', 'TUE')).to eq('0500-1830')
    end

    it 'can extract closed sattus' do
      expect(described_class.extract('MON-WED CLOSED', 'MON')).to eq('CLOSED')
    end
  end
end
