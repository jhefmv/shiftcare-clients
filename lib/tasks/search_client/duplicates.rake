require 'json'
require 'optparse'
require 'colorize'

namespace :search_clients do
  desc 'Find any client with the same email or name'
  task :duplicates, [:field, :file_path] do |t, args|
    results, error = SearchClient::Duplicate.call(field: args[:field], file_path: args[:file_path])
    return puts error.colorize(:red) if error

    if results.empty?
      puts 'Your query yielded no results.'.colorize(:blue)
    else
      puts 'Duplicates:'.colorize(:green)
      results.each do |k, clients|
        puts "  #{k}:"
        clients.each do |client|
          puts "  -- ID: #{client['id']}, Name: #{client['full_name']}, Email: #{client['email']}"
        end
      end
    end
  end
end