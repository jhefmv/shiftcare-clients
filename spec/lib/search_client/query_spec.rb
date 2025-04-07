# frozen_string_literal: true

RSpec.describe SearchClient::Query do
  describe '.call' do
    let(:valid_json) { 'spec/fixtures/clients.json' }
    let(:invalid_json) { 'spec/fixtures/invalid_clients.json' }
    let(:client_doe) { { id: 1, full_name: 'John Doe', email: 'john.doe@gmail.com' } }
    let(:client_jane) { { id: 2, full_name: 'Jane Smith', email: 'jane.smith@yahoo.com' } }
    let(:client_jane_2) { { id: 15, full_name: 'Another Jane Smith', email: 'jane.smith@yahoo.com' } }

    it 'returns empty results' do
      results, error = described_class.call(field: 'name', query: 'xSmithx')

      expect(results).to be_empty
      expect(error).to be_nil
    end

    it 'returns partial matches' do
      results, error = described_class.call(field: 'name', query: 'Smith')

      expect(results.map { |r| r.transform_keys(&:to_sym) }).to contain_exactly(client_jane, client_jane_2)
      expect(error).to be_nil
    end

    it 'returns partial matches from provided JSON file' do
      results, error = described_class.call(field: 'name', query: 'Doe', file_path: valid_json)

      expect(results.map { |r| r.transform_keys(&:to_sym) }).to contain_exactly(client_doe)
      expect(error).to be_nil
    end

    it 'returns error when JSON file is not found' do
      results, error = described_class.call(field: 'name', query: 'Smith', file_path: 'missing.json')

      expect(results).to be_empty
      expect(error).to eql('JSON file cannot be found!')
    end

    it 'returns error when JSON file is invalid' do
      results, error = described_class.call(field: 'name', query: 'Smith', file_path: invalid_json)

      expect(results).to be_empty
      expect(error).to eql('JSON file cannot be parsed!')
    end
  end
end