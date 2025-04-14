# frozen_string_literal: true

module SearchClient
  class Query < Base

    def call
      raise 'Missing field or keyword!' unless @field && @keyword

      query
    end

    private

    def query
      return unless json_data

      json_data.select do |client|
        client[@field] && client[@field].match?(Regexp.new(@keyword, 'i'))
      end
    end
  end
end
