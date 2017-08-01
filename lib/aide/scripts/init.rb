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
      end
    end
  end
end
