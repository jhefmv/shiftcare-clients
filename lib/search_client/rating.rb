# frozen_string_literal: true

module SearchClient
  class Rating < Base

    def initialize(**options)
      super
      @value = options[:value]
    end

    def call
      raise 'Missing field or value!' unless @field && @value

      query
    end

    private

    def query
      return unless json_data

      json_data.select do |client|
        client[@field] && client[@field].to_f >= @value.to_f
      end
    end
  end
end
