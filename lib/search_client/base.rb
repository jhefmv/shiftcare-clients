# frozen_string_literal: true

require 'json'

module SearchClient
  class Base
    DATA_FILE_PATH = File.join(%w(data))
    DATA_FILE_NAME = 'clients.json'.freeze
    FILE_NOT_FOUND_MSG = 'JSON file cannot be found!'.freeze
    FILE_INVALID_MSG = 'JSON file cannot be parsed!'.freeze

    def self.call(**)
      new(**).call
    end

    def call
      raise NotImplementedError, "#{self.class}##{__method__} is not implemented."
    end

    def initialize(options)
      @field = options[:field] == 'name' ? 'full_name' : options[:field]
      @query = options[:query]
      @json_file = options[:file_path] || File.join(DATA_FILE_PATH, DATA_FILE_NAME)
    end

    private

    def json_data
      return @json_data unless @json_data.nil?

      begin
        if File.exist?(@json_file)
          @json_data = [JSON.parse(File.read(@json_file)), nil]
        else
          @json_data = [[], FILE_NOT_FOUND_MSG]
        end
      rescue JSON::ParserError
        @json_data = [[], FILE_INVALID_MSG]
      end
    end
  end
end