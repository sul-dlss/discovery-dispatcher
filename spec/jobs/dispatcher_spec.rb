require 'rails_helper'

describe DispatcherJob do
  describe '#perform' do
    let(:records) do
      [
        { "druid" => "", "latest_change" => "2014-01-01T12:00:00 -0800" }, { "druid" => "", "latest_change" => "2014-01-01T12:00:00 -0800" }
      ]
    end
    let(:api_instance) { instance_double(PurlFetcher::API) }
    let(:record_instance) { instance_double(PurlFetcher::RecordChanges, fanout: true) }
    before do
      allow(PurlFetcher::API).to receive(:new).and_return(api_instance)
    end
    it 'runs correctly when all data is available' do
      start_time = Time.zone.parse('2012-01-01T12:00:00 -0800')
      end_time = Time.zone.parse('2014-01-01T12:00:00 -0800')
      expect(ReaderLogRecords).to receive(:last_read_time).and_return(start_time)
      expect(Time).to receive(:now).and_return(end_time).at_least(:once)
      expect(api_instance).to receive(:deletes).and_return(records)
        .with(first_modified: start_time).and_return(records)
      expect(api_instance).to receive(:changes)
        .with(first_modified: start_time).and_return(records)
      records.each do |record|
        expect(PurlFetcher::RecordChanges).to receive(:new).with(record.deep_symbolize_keys).and_return(record_instance)
        expect(PurlFetcher::RecordDeletes).to receive(:new).with(record.deep_symbolize_keys).and_return(record_instance)
      end
      expect(ReaderLogRecords).to receive(:set_last_fetch_info).with(end_time, records.length * 2)
      expect { described_class.perform_now }.not_to raise_error
    end
    it 'returns an exception if one of the calls rails' do
      allow(api_instance).to receive(:changes).and_raise(Exception.new)
      expect { described_class.perform_now }.to raise_error(Exception)
    end
  end
end
