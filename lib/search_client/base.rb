# frozen_string_literal: true

require 'json'

module SearchClient
  class Base
    DATA_FILE_PATH = File.join(*%w[data])
    DATA_FILE_NAME = 'clients.json'
    FILE_NOT_FOUND_MSG = 'JSON file cannot be found!'
    FILE_INVALID_MSG = 'JSON file cannot be parsed!'

    def self.call(**)
      new(**).call
    end

    def call
      raise NotImplementedError, "#{self.class}##{__method__} is not implemented."
    end

    def initialize(**options)
      @field = options[:field] == 'name' ? 'full_name' : options[:field]
      @keyword = options[:keyword]
      @json_file = options[:file_path] || File.join(DATA_FILE_PATH, DATA_FILE_NAME)
    end

    private

    def json_data
      begin
        raise FILE_NOT_FOUND_MSG unless File.exist?(@json_file)

        JSON.parse(File.read(@json_file))
      rescue JSON::ParserError
        raise FILE_INVALID_MSG
      end
    end
  end
end