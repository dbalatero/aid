# frozen_string_literal: true

module Aid
  module Scripts
    class Doctor < Aid::Script
      def self.description
        'Checks the health of your development environment'
      end

      def self.help
        'doctor - helps you diagnose any setup issues with this application'
      end

      def initialize(*args)
        super
        @checks = []
      end

      def check(**options)
        check = Check.new(options)
        @checks << check

        check.run!
      end

      def run
        puts <<~HELP
          To implement this script for your repository, create the following
          file in #{colorize(:green, "#{aid_directory}/doctor.rb")}:

          class Doctor < Aid::Scripts::Doctor
            def run
              check_phantomjs_installed
            end

            private

            def check_phantomjs_installed
              check name: "PhantomJS installed",
                command: "which phantomjs",
                remedy: command("brew install phantomjs")
            end
          end

          You can add as many checks to your script as you want.
        HELP

        exit
      end

      def problems
        @checks.map(&:problems).flatten
      end

      def exit_code
        problems.size
      end

      def command(cmd)
        CommandRemedy.new(cmd)
      end

      class Remedy
        def initialize(message)
          @message = message
        end

        def auto_fixable?
          false
        end

        def auto_fix!
          # By default, we don't know how to auto-fix
        end

        def to_s
          message
        end

        private

        attr_reader :message
      end

      class CommandRemedy < Remedy
        include Aid::Colorize

        alias shell_command message

        def initialize(shell_command)
          super
        end

        def auto_fixable?
          true
        end

        def auto_fix!
          puts "==> running #{colorize(:command, "$ #{shell_command}")}"
          system(shell_command)
        end

        def to_s
          "run #{colorize :command, shell_command}"
        end
      end

      class Check
        include Aid::Colorize

        attr_reader :name, :command, :remedy, :problems

        def initialize(name:, command:, remedy:)
          @name = name
          @command = command
          @remedy = remedy.is_a?(Remedy) ? remedy : Remedy.new(remedy)
          @problems = []
          @checked_once = false
        end

        def run!
          print "Checking: #{name}... "

          success = run_command

          if success
            puts 'OK'
          else
            puts colorize(:error, 'F')

            if @checked_once || !remedy.auto_fixable?
              puts "\n  To fix: #{remedy}\n\n"
              problems << name
            elsif remedy.auto_fixable?
              @checked_once = true

              puts '==> attempting autofix'
              remedy.auto_fix!
              puts '==> retrying check'
              run!
            end
          end
        end

        private

        def run_command
          if command.respond_to?(:call)
            command.call
          else
            system "#{command} > /dev/null 2>&1"
          end
        end
      end
    end
  end
end
