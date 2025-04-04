# frozen_string_literal: true

require_relative 'helpers/search_client_helper'

module SearchClient
  class Query
    include SearchClientHelper

    def self.call(field:, query:, **)
      new(field:, query:, **).call
    end

    def initialize(options)
      @field = options[:field] == 'name' ? 'full_name' : options[:field]
      @query = options[:query]
      @json_file = options[:file_path] || File.join(DATA_FILE_PATH, DATA_FILE_NAME)
    end

    def call
      query
    end

    private

    def query
      if json_data[0].empty?
        json_data
      else
        matched_clients = json_data[0].select do |client|
          client[@field] && client[@field].match?(Regexp.new(@query, 'i'))
        end
        [matched_clients, nil]
      end
    end
  end
end
