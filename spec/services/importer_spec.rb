require 'rails_helper'

describe Importer do
  describe '#process' do
    context 'when empty data file is passed in' do
      let(:data) { '' }

      it 'returns true' do
        expect(subject.process(data)).to be_truthy
      end

      it 'has no errors' do
        subject.process(data)
        expect(subject.errors).to be_nil
      end

      it 'does not create any database entries' do
        expect(OpeningTime).not_to receive(:build)
        subject.process(data)
      end
    end

    context 'when data file containing opening time data is passed in' do
      let(:data) { %{B0508/15 NOTAMN
Q) ESAA/QFAAH/IV/NBO/A /000/999/5746N01404E005
A) ESGJ B) 1503020000 C) 1503222359
E) AERODROME HOURS OF OPS/SERVICE MON 0500­2000 TUE­THU 0500­2100 FRI
0545­2100 SAT0630­0730 1900­2100 SUN CLOSED
CREATED: 26 Feb 2015 10:54:00
SOURCE: EUECYIYN}
      }

      it 'returns true' do
        expect(subject.process(data)).to be_truthy
      end

      it 'has no errors' do
        subject.process(data)
        expect(subject.errors).to be_nil
      end

      it 'creates a database entry' do
        expect(OpeningTime).to receive(:build)
        subject.process(data)
      end
    end

    context 'when data file containing NON opening time data is passed in' do
      let(:data) { %{B0517/15 NOTAMN
Q) ESAA/QSTAH/IV/BO /A /000/999/5746N01404E005
A) ESGJ B) 1502271133 C) 1503012359
E) AERODROME CONTROL TOWER (TWR) HOURS OF OPS/SERVICE MON-THU
0000-0100, 0500-2359 FRI 0000-0100, 0730-2100 SAT 0630-0730,
1900-2100 SUN 2200-2359
CREATED: 27 Feb 2015 11:35:00
SOURCE: EUECYIYN}
      }

      it 'returns true' do
        expect(subject.process(data)).to be_truthy
      end

      it 'has no errors' do
        subject.process(data)
        expect(subject.errors).to be_nil
      end

      it 'creates a database entry' do
        expect(OpeningTime).not_to receive(:build)
        subject.process(data)
      end
    end

    context 'when an error occurs during processing' do
      let(:data) { "AERODROME HOURS OF OPS\/SERVICE\nData with errors" }
      before do
        allow(OpeningTime).to receive(:build).and_raise(StandardError, 'Failure during processing')
      end

      it 'returns true' do
        expect(subject.process(data)).to be_falsey
      end

      it 'has errors' do
        subject.process(data)
        expect(subject.errors).to eq('Failure during processing')
      end

      it 'roles back any processed records if the failure happens halfway through' do
        pending 'out of scope'
        fail
      end
    end
  end
end
