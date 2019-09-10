# frozen_string_literal: true

module Aid
  module Scripts
    class Init < Aid::Script
      def self.description
        'Sets up aid in your project'
      end

      def run
        step 'Creating .aid directory' do
          system! "mkdir -p #{aid_directory}"
        end

        puts
        puts 'All done! To create your first script, run '\
          "#{colorize(:green, 'aid new [script-name]')}"
      end
    end
  end
end
