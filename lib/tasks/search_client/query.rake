# frozen_string_literal: true

# require 'json'
# require 'optparse'
require 'colorize'

namespace :search_clients do
  desc 'Query clients and return those partially matching with a given search query'
  task :query, [:field, :keyword, :file_path] do |t, args|
    begin
      results = SearchClient::Query.call(field: args[:field], keyword: args[:keyword], file_path: args[:file_path])
      if results.empty?
        puts 'Your query yielded no results.'.colorize(:blue)
      else
        puts 'Matches:'.colorize(:green)
        results.each do |client|
          puts "  - ID: #{client['id']}, Name: #{client['full_name']}, Email: #{client['email']}"
        end
      end
    rescue StandardError => e
      puts "Something went wrong! #{e}".colorize(:red)
      puts SearchClient::Cli.help
    end
  end
end