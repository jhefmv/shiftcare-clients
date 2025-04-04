# frozen_string_literal: true

require 'open3'

RSpec.describe 'search_client command line script' do
  let(:script) { 'bin/search_clients' }
  let(:json_file) { 'spec/fixtures/clients.json' }
  let(:invalid_json) { 'spec/fixtures/invalid_clients.json' }
  let(:duplicates_json) { 'spec/fixtures/duplicate_clients.json' }
  let(:unique_json) { 'spec/fixtures/unique_clients.json' }

  describe 'query command' do
    context 'by name' do
      it 'prints matched clients from default json file' do
        output, status = Open3.capture2(script, 'query', '-f', 'name', '-q', 'am')
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('ID: 4, Name: Michael Williams, Email: michael.williams@outlook.com')
        expect(output).to include('ID: 16, Name: Benjamin Lee, Email: benjamin.lee@gmail.com')
      end

      it 'prints matched clients from provided json file' do
        output, status = Open3.capture2(script, 'query', '--field', 'name', '--query', 'mit', '--file-path', json_file)
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('')
        expect(output).to include('')
        expect(output).to include('ID: 2, Name: Jane Smith, Email: jane.smith@yahoo.com')
        expect(output).to include('ID: 15, Name: Another Jane Smith, Email: another.jane.smith@yahoo.com')
      end

      it 'returns no results when query has no match' do
        output, status = Open3.capture2(script, 'query', "--field", 'name', '--query', 'smiths')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Your query yielded no results.')
      end

      it 'prints usage message when field option is not provided' do
        output, status = Open3.capture2(script, 'query', "--query", 'Name')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_clients query --field=<name|email> --query=KEYWORD --file-path=FILE_PATH')
      end

      it 'prints usage message when query option is not provided' do
        output, status = Open3.capture2(script, 'query', "--field", 'name')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_clients query --field=<name|email> --query=KEYWORD --file-path=FILE_PATH')
      end
    end

    context 'by email' do
      it 'prints matched clients from default file' do
        output, status = Open3.capture2(script, 'query', '--field', 'email', '--query', 'smith@yahoo')
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('ID: 2, Name: Jane Smith, Email: jane.smith@yahoo.com')
        expect(output).to include('ID: 15, Name: Another Jane Smith, Email: jane.smith@yahoo.com')
      end

      it 'prints matched clients from provided file' do
        output, status = Open3.capture2(script, 'query', '--field', 'email', '--query', 'smith@yahoo', '--file-path', json_file)
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('ID: 2, Name: Jane Smith, Email: jane.smith@yahoo.com')
        expect(output).to include('ID: 15, Name: Another Jane Smith, Email: another.jane.smith@yahoo.com')
      end

      it 'returns no results when query has no match' do
        output, status = Open3.capture2(script, 'query', "--field", 'email', '--query', 'smiths')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Your query yielded no results')
      end

      it 'prints usage message when field is not provided' do
        output, status = Open3.capture2(script, 'query', "--query", 'email@email.com')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_clients query --field=<name|email> --query=KEYWORD --file-path=FILE_PATH')
      end

      it 'prints usage message when value is not provided' do
        output, status = Open3.capture2(script, 'query', "--field", 'email')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_clients query --field=<name|email> --query=KEYWORD --file-path=FILE_PATH')
      end
    end

    context 'with missing and invalid options' do
      it 'prints invalid option error' do
        output, status = Open3.capture2(script, 'query', "--fieldx", 'id')

        expect(status.exitstatus).to eq(1)
        expect(output).to include('invalid option')
      end

      it 'prints missing argument error' do
        output, status = Open3.capture2(script, 'query', "--field")

        expect(status.exitstatus).to eq(1)
        expect(output).to include('missing argument')
      end

      it 'prints usage message' do
        output, status = Open3.capture2(script, 'query')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_clients query --field=<name|email> --query=KEYWORD --file-path=FILE_PATH')
      end
    end

    context 'with missing file' do
      it 'prints error message' do
        output, status = Open3.capture2(script, 'query', '--field', 'name', '--query', 'smith', '--file-path', 'missing_file')
        expect(status.exitstatus).to eq(0)
        expect(output).to include('JSON file cannot be found!')
      end
    end

    context 'with invalid file' do
      it 'prints error message' do
        output, status = Open3.capture2(script, 'query', '--field', 'name', '--query', 'smith', '--file-path', invalid_json)
        expect(status.exitstatus).to eq(0)
        expect(output).to include('JSON file cannot be parsed!')
      end
    end
  end

  describe 'duplicate command' do
    context 'by name' do
      it 'prints matched clients from provided json file' do
        output, status = Open3.capture2(script, 'duplicates', '--field', 'name', '--file-path', duplicates_json)
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('ID: 1, Name: John Doe')
        expect(output).to include('ID: 3, Name: John Doe')
      end

      it 'returns no results when query has no match' do
        output, status = Open3.capture2(script, 'duplicates', "--field", 'name')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Your query yielded no results')
      end
    end

    context 'by email' do
      it 'returns matched results from default file' do
        output, status = Open3.capture2(script, 'duplicates', "--field", 'email')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('ID: 2, Name: Jane Smith, Email: jane.smith@yahoo.com')
        expect(output).to include('ID: 15, Name: Another Jane Smith, Email: jane.smith@yahoo.com')
      end

      it 'prints matched clients from provided file' do
        output, status = Open3.capture2(script, 'duplicates', '--field', 'email', '--file-path', duplicates_json)
    
        expect(status.exitstatus).to eq(0)
        expect(output).to include('ID: 2, Name: Jane Smith, Email: jane.smith@yahoo.com')
        expect(output).to include('ID: 4, Name: Michael Williams, Email: jane.smith@yahoo.com')
      end

      it 'returns no results when query has no match' do
        output, status = Open3.capture2(script, 'duplicates', "--field", 'email' '--file-path', unique_json)

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Your query yielded no results')
      end
    end

    context 'with missing file' do
      it 'prints error message' do
        output, status = Open3.capture2(script, 'duplicates', '--field', 'name', '--file-path', 'missing_file')
        expect(status.exitstatus).to eq(0)
        expect(output).to include('JSON file cannot be found!')
      end
    end

    context 'with invalid file' do
      it 'prints error message' do
        output, status = Open3.capture2(script, 'duplicates', '--field', 'email', '--file-path', invalid_json)
        expect(status.exitstatus).to eq(0)
        expect(output).to include('JSON file cannot be parsed!')
      end
    end

    context 'with missing and invalid options' do
      it 'prints invalid option error' do
        output, status = Open3.capture2(script, 'duplicates', "--fieldx", 'id')

        expect(status.exitstatus).to eq(1)
        expect(output).to include('invalid option')
      end

      it 'prints missing argument error' do
        output, status = Open3.capture2(script, 'duplicates', "--field")

        expect(status.exitstatus).to eq(1)
        expect(output).to include('missing argument')
      end

      it 'prints usage message' do
        output, status = Open3.capture2(script, 'duplicates')

        expect(status.exitstatus).to eq(0)
        expect(output).to include('Usage: bin/search_clients duplicates --field=<name|email> --file-path=FILE_PATH')
      end
    end
  end

  describe 'invalid command' do
    it 'prints error message' do
      output, status = Open3.capture2(script, 'invalid_command')
      expect(status.exitstatus).to eq(0)
      expect(output).to include('Usage: bin/search_clients query|duplicates [options]')
      expect(output).to include('-f, --field FIELD                Field name to search')
      expect(output).to include('-q, --query VALUE                Keyword to search for')
      expect(output).to include('-p, --file-path FILE_PATH        Optional path to file')
    end
  end
end
