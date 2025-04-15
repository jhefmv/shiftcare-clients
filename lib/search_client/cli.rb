# frozen_string_literal: true

require 'optparse'
require 'colorize'

module SearchClient
  class Cli
    def self.help
      <<~TEXT
        Usage: search_clients COMMAND [options]
        Commands:
          query             - Search partially
          duplicates        - Find duplicates

        Options:
          --field, -f       - Name of field to search for
          --keyword, -k     - Keyword to search for
          --file-path, -p   - Optional path to file
          -h, --help        - Show help message
      TEXT
    end

    def run(args = ARGV)
      begin
        command = args.shift || 'help'
        options = parse_options(args) if command

        case command
        when 'query'
          query(options)
        when 'duplicates'
          duplicates(options)
        when 'rating'
          rating(options)
        when 'help'
          puts help
        else
          puts "Unknown command: #{command}".colorize(:red)
          puts help
          exit 1
        end
      rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
        puts e.to_s.colorize(:red)
        puts help
        exit 1
      rescue => e
        puts "Something went wrong! #{e}".colorize(:red)
        puts help
        exit 1
      end
    end

    private

    def parse_options(args)
      options = {}
      op = OptionParser.new do |parser|
        parser.banner = 'Usage: search_clients COMMAND [options]'
        parser.on('-f', '--field NAME', 'Field name to search') { |v| options[:field] = v.to_s.strip }
        parser.on('-k', '--keyword VALUE', 'Keyword to search for') { |v| options[:keyword] = v.to_s.strip }
        parser.on('-v', '--value VALUE', 'Value to search for') { |v| options[:value] = v.to_s.strip }
        parser.on('-p', '--file-path FILE_PATH', 'Optional path to file') { |v| options[:file_path] = v.to_s.strip }
      end
      op.parse!(args)
      options
    end

    def help
      self.class.help
    end

    def query(args)
      results = SearchClient::Query.call(**args)
      if results.empty?
        puts 'Your query yielded no results.'.colorize(:blue)
      else
        puts 'Matches:'.colorize(:green)
        results.each do |client|
          puts "  - ID: #{client['id']}, Name: #{client['full_name']}, Email: #{client['email']}"
        end
      end
    end

    def duplicates(args)
      results = SearchClient::Duplicate.call(**args)
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

    def rating(args)
      results = SearchClient::Rating.call(**args)
      if results.empty?
        puts 'Your query yielded no results.'.colorize(:blue)
      else
        puts 'Matches:'.colorize(:green)
        results.each do |client|
          puts "  - ID: #{client['id']}, Name: #{client['full_name']}, Email: #{client['email']}, Rating: #{client['rating']}"
        end
      end
    end
  end
end
