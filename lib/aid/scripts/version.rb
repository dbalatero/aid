# frozen_string_literal: true
#
require_relative '../version'

module Aid
  module Scripts
    class Version < Aid::Script
      def self.description
        'Displays the current version'
      end

      def run
        puts Aid::VERSION
      end
    end
  end
end


