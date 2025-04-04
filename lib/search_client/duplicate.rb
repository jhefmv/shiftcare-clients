# frozen_string_literal: true

require_relative 'helpers/search_client_helper'

module SearchClient
  class Duplicate
    include SearchClientHelper

    def self.call(field:, **)
      new(field:, **).call
    end

    def initialize(options)
      @field = options[:field] == 'name' ? 'full_name' : options[:field]
      @json_file = options[:file_path] || File.join(DATA_FILE_PATH, DATA_FILE_NAME)
    end

    def call
      find_duplicates
    end

    private

    def find_duplicates
      if json_data[0].empty?
        json_data
      else
        duplicate_clients = json_data[0].group_by { |c| c[@field] }
                                        .select { |v, g| v && g.size > 1 }
        [duplicate_clients, nil]
      end
    end
  end
end
