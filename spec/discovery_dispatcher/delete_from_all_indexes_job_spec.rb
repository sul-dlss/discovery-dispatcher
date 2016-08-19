require 'rails_helper'

describe DiscoveryDispatcher::DeleteFromAllIndexesJob do
  describe '.perform' do
    it 'performs the indexing process successfully' do
      stub_request(:delete, 'http://www.example-indexer.com/items/xz404nk7341').
        to_return(status: 200)
      index_job = described_class.new('delete', 'xz404nk7341', 'searchworkspreview')
      expect(Rails.logger).to receive(:debug).with(/Processing/).and_call_original
      expect(Rails.logger).to receive(:info).with(/Completed/).and_call_original
      index_job.perform
    end
  end
  describe '.build_request_url' do
    it 'builds a URL that references the base_indexer v3 api /items/:druid path' do
      expect(subject.build_request_url('ab123cd4567', 'http://www.example.com', ''))
        .to eq 'http://www.example.com/items/ab123cd4567'
    end
  end
  describe '.run_request' do
    let(:url) { 'http://www.example.com/items/xz404nk7341' }
    let(:connection) { instance_double(Faraday::Connection) }
    before do
      expect(Faraday).to receive(:new).with(url: url).and_return(connection)
    end
    it 'runs a delete for a found purl page' do
      expect(connection).to receive(:delete)
        .and_return(instance_double('Faraday::Response', status: 200))
      expect(subject.run_request('xz404nk7341', 'delete', url)).to be nil
    end
    it 'raises an exception for not found purl with response 202' do
      expect(connection).to receive(:delete)
        .and_return(instance_double('Faraday::Response', status: 202))
      expect { subject.run_request('xz404nk7341', 'delete', url) }.to raise_error(RuntimeError)
    end
  end
end