# frozen_string_literal: true

require_relative '../main'

RSpec.describe SearchClient::Duplicate do
  describe '.call' do
    let(:valid_json) { 'spec/fixtures/clients.json' }
    let(:invalid_json) { 'spec/fixtures/invalid_clients.json' }
    let(:duplicates_json) { 'spec/fixtures/duplicate_clients.json' }
    let(:client_doe) { { id: 1, full_name: 'John Doe', email: 'john.doe@gmail.com' } }
    let(:client_jane) { { id: 2, full_name: 'Jane Smith', email: 'jane.smith@yahoo.com' } }
    let(:client_michael) { { id: 4, full_name: 'Michael Williams', email: 'jane.smith@yahoo.com' } }
    let(:client_jane_2) { { id: 15, full_name: 'Another Jane Smith', email: 'jane.smith@yahoo.com' } }

    it 'returns empty results' do
      results, error = described_class.call(field: 'name')

      expect(results).to be_empty
      expect(error).to be_nil
    end

    it 'returns duplicate entries' do
      results, error = described_class.call(field: 'email')
      expect(results.keys).to contain_exactly(client_jane[:email])
      expect(results.values[0].map { |r| r.transform_keys(&:to_sym) }).to contain_exactly(client_jane, client_jane_2)
      expect(error).to be_nil
    end

    it 'returns duplicate entries from provided JSON file' do
      results, error = described_class.call(field: 'email', file_path: duplicates_json)

      expect(results.values[0].map { |r| r.transform_keys(&:to_sym) }).to contain_exactly(client_jane, client_michael)
      expect(error).to be_nil
    end

    it 'returns error when JSON file is not found' do
      results, error = described_class.call(field: 'email', file_path: 'missing.json')

      expect(results).to be_empty
      expect(error).to eql('JSON file cannot be found!')
    end

    it 'returns error when JSON file is invalid' do
      results, error = described_class.call(field: 'email', file_path: invalid_json)

      expect(results).to be_empty
      expect(error).to eql('JSON file cannot be parsed!')
    end
  end
end