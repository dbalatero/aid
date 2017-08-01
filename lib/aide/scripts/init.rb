module Aide
  module Scripts
    class Init < Aide::Script
      def self.description
        "Sets up aide in your project"
      end

      def run
        step "Creating .aide directory" do
          system! "mkdir -p ./.aide"
        end

        puts
        puts "All done! To create your first script, run "\
          "#{colorize(:green, "aide new [script-name]")}"
      end
    end
  end
end
