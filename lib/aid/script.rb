module Aid
  class Script
    include Aid::Colorize
    include Aid::Inheritable

    def self.name
      klass_name = self.to_s.split('::').last

      klass_name
        .scan(/[A-Z][a-z0-9]*/)
        .map(&:downcase)
        .join('-')
    end

    def exit_with_help!
      puts self.class.help
      exit
    end

    def self.help
      <<~HELP
        Help has not been implemented for "#{name}". Please implement a
        help method like so:

        class #{self} < Aid::Script
          def self.help
            <<-EOF
            My awesome help message here.
            This will be so useful for people.
            EOF
          end
        end
      HELP
    end

    def self.description
      ""
    end

    def help
      self.class.help
    end

    def description
      self.class.description
    end

    attr_reader :argv

    def initialize(*argv)
      @argv = *argv
    end

    def self.run(*argv)
      new(*argv).run
    end

    def run
      raise NotImplementedError
    end

    def exit_code
      0
    end

    def system!(*args)
      puts colorize(:command, args.join(" "))
      system(*args) || abort(colorize(:error, "\n== Command #{args} failed =="))
    end

    def step(name)
      puts colorize(:info, "\n== #{name} ==")
      yield if block_given?
    end

    private

    def aid_directory
      "./.aid"
    end
  end
end
