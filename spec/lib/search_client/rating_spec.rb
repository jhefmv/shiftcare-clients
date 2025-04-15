# frozen_string_literal: true

RSpec.describe SearchClient::Rating do
  describe '.call' do
    let(:valid_json) { 'spec/fixtures/staff.json' }
    let(:invalid_json) { 'spec/fixtures/invalid_clients.json' }
    let(:ratings_greater_than4) do
      [
        {
          "id": 2,
          "full_name": "Jane Doe",
          "position": "Accountant",
          "department": "Finance",
          "email": "jane.doe@example.com",
          "rating": 4.2
        },
        {
          "id": 4,
          "full_name": "Emily Brown",
          "position": "Designer",
          "department": "Creative",
          "email": "emily.brown@example.com",
          "rating": 4.0
        },
        {
          "id": 5,
          "full_name": "Mike Johnson",
          "position": "Developer",
          "department": "IT",
          "email": "michael.johnson@example.com",
          "rating": 4.6
        }
      ]
    end
    let(:ratings_greater_than42) do
      [
        {
          "id": 2,
          "full_name": "Jane Doe",
          "position": "Accountant",
          "department": "Finance",
          "email": "jane.doe@example.com",
          "rating": 4.2
        },
        {
          "id": 5,
          "full_name": "Mike Johnson",
          "position": "Developer",
          "department": "IT",
          "email": "michael.johnson@example.com",
          "rating": 4.6
        }
      ]
    end
    let(:missing_field_or_value) { 'Missing field or value!' }

    it 'returns empty results' do
      results = described_class.call(field: 'rating', value: 50)
      expect(results).to be_empty
    end

    it 'returns ratings >= 4' do
      results = described_class.call(field: 'rating', value: 4, file_path: valid_json)
      expect(results.map { |r| r.transform_keys(&:to_sym) }).to match_array(ratings_greater_than4)
    end

    it 'returns ratings >= 4.2' do
      results = described_class.call(field: 'rating', value: 4.2, file_path: valid_json)
      expect(results.map { |r| r.transform_keys(&:to_sym) }).to match_array(ratings_greater_than42)
    end

    it 'returns ratings >= "4.2"' do
      results = described_class.call(field: 'rating', value: '4.2', file_path: valid_json)
      expect(results.map { |r| r.transform_keys(&:to_sym) }).to match_array(ratings_greater_than42)
    end

    it 'returns error when JSON file is not found' do
      expect { described_class.call(field: 'rating', value: 1, file_path: 'missing.json') }
        .to raise_error('JSON file cannot be found!')
    end

    it 'returns error when JSON file is invalid' do
      expect { described_class.call(field: 'rating', value: 2, file_path: invalid_json) }
        .to raise_error('JSON file cannot be parsed!')
    end

    it 'returns error when field is missing' do
      expect { described_class.call(value: 1) }.to raise_error(missing_field_or_value)
    end

    it 'returns error when value is missing' do
      expect { described_class.call(field: 'rating') }.to raise_error(missing_field_or_value)
    end
  end
end
