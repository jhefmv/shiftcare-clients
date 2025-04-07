# frozen_string_literal: true

module SearchClient
  class Query < Base

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
