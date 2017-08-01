module Aid
  module Scripts
    class New < Aid::Script
      def self.description
        "Generates a new script in the aid directory"
      end

      def self.help
        <<~HELP
        Usage: aid new [script name]

        Generates a new script file in the aid script directory.

        Example:
          #{colorize(:green, "$ aid new my-script-name")}

          will generate a new script called my_script_name.rb
        HELP
      end

      def run
        exit_with_help! unless script_name
        check_for_aid_directory!

        step "Creating #{output_path}" do
          File.open(output_path, "wb") do |fp|
            fp.write(template)
          end

          puts
          print "Successfully created "
          puts colorize(:green, output_path)
        end
      end

      private

      def output_path
        "#{aid_directory}/#{output_filename}"
      end

      def output_filename
        "#{script_name.gsub(/-/, "_")}.rb"
      end

      def check_for_aid_directory!
        unless Dir.exist?(aid_directory)
          abort "The #{colorize(:green, aid_directory)} directory is "\
            "missing. Please run #{colorize(:green, "aid init")} to create it."
        end
      end

      def template
        <<~RUBY
        class #{class_name} < Aid::Script
          def self.description
            "FILL ME IN"
          end

          def self.help
            <<~HELP
            Fill me in.
            HELP
          end

          def run
          end
        end
        RUBY
      end

      def class_name
        script_name
          .split("-")
          .map { |token| token[0].upcase + token[1..-1] }
          .join
      end

      def script_name
        argv.first
      end
    end
  end
end
