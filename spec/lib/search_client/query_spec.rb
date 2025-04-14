# frozen_string_literal: true

RSpec.describe SearchClient::Query do
  describe '.call' do
    let(:valid_json) { 'spec/fixtures/clients.json' }
    let(:invalid_json) { 'spec/fixtures/invalid_clients.json' }
    let(:client_doe) { { id: 1, full_name: 'John Doe', email: 'john.doe@gmail.com' } }
    let(:client_jane) { { id: 2, full_name: 'Jane Smith', email: 'jane.smith@yahoo.com' } }
    let(:client_jane2) { { id: 15, full_name: 'Another Jane Smith', email: 'jane.smith@yahoo.com' } }
    let(:missing_field_or_keyword) { 'Missing field or keyword!' }

    it 'returns empty results' do
      results = described_class.call(field: 'name', keyword: 'xSmithx')
      expect(results).to be_empty
    end

    it 'returns partial matches' do
      results = described_class.call(field: 'name', keyword: 'Smith')
      expect(results.map { |r| r.transform_keys(&:to_sym) }).to contain_exactly(client_jane, client_jane2)
    end

    it 'returns partial matches from provided JSON file' do
      results = described_class.call(field: 'name', keyword: 'Doe', file_path: valid_json)
      expect(results.map { |r| r.transform_keys(&:to_sym) }).to contain_exactly(client_doe)
    end

    it 'returns error when JSON file is not found' do
      expect { described_class.call(field: 'name', keyword: 'Smith', file_path: 'missing.json') }
        .to raise_error('JSON file cannot be found!')
    end

    it 'returns error when JSON file is invalid' do
      expect { described_class.call(field: 'name', keyword: 'Smith', file_path: invalid_json) }
        .to raise_error('JSON file cannot be parsed!')
    end

    it 'returns error when field is missing' do
      expect { described_class.call(keyword: 'Smith') }.to raise_error(missing_field_or_keyword)
    end

    it 'returns error when keyword is missing' do
      expect { described_class.call(field: 'name') }.to raise_error(missing_field_or_keyword)
    end
  end
end