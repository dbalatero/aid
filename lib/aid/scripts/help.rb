# frozen_string_literal: true

module Aid
  module Scripts
    class Help < Aid::Script
      attr_reader :script

      def initialize(*argv)
        super

        script_name = argv.first
        @script = Aid::Script.scripts[script_name]
      end

      def self.description
        'Displays help information'
      end

      def self.help
        ''
      end

      def run
        if script
          puts "Help for #{colorize(:light_blue, script.name)}:"

          puts script.help
          puts
        else
          basic_usage
        end
      end

      private

      def basic_usage
        puts "Usage: aid #{colorize(:light_blue, '[script name]')}"
        puts
        puts 'Specify a specific script to run, options are: '
        puts

        scripts = Hash[Aid::Script.scripts.sort]

        names_and_descriptions = scripts.map do |name, script|
          [
            colorize(:light_green, name),
            colorize(:light_blue, script.description)
          ]
        end

        padding = names_and_descriptions.map { |name, _| name.length }.max

        names_and_descriptions.each do |name, description|
          puts format("  %-#{padding}s %s", name, description)
        end

        puts
      end
    end
  end
end
