# frozen_string_literal: true

module SearchClient
  class Duplicate < Base

    def call
      raise 'Missing field!' unless @field

      find_duplicates
    end

    private

    def find_duplicates
      return unless json_data

      json_data.group_by { |c| c[@field] }.select { |v, g| v && g.size > 1 }
    end
  end
end
