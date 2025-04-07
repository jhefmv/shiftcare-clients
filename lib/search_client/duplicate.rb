# frozen_string_literal: true

module SearchClient
  class Duplicate < Base

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
