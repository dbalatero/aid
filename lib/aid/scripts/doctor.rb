module Aid
  class Doctor < Aid::Script
    class Check
      include Aid::Colorize

      attr_reader :name, :command, :remedy, :problems

      def initialize(name:, command:, remedy:)
        @name = name
        @command = command
        @remedy = remedy
        @problems = []
      end

      def run!
        print "Checking: #{name}... "

        success = if command.respond_to?(:call)
          command.call
        else
          system "#{command} > /dev/null 2>&1"
        end

        if success
          puts 'OK'
        else
          print colorize(:error, 'F')
          fix = remedy.respond_to?(:join) ? remedy.join(" ") : remedy
          puts "\n  To fix: #{colorize(:command, fix)}\n\n"

          problems << name
        end
      end
    end

    def self.description
      "Checks the health of your development environment"
    end

    def self.help
      "doctor - helps you diagnose any setup issues with this application"
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

    def with_checks(&block)
      yield
      report
    end

    def problems
      @checks.map(&:problems).flatten
    end

    def report
      exit problems.size
    end

    def command(s)
      "run #{colorize :command, s}"
    end
  end
end
