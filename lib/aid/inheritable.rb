# frozen_string_literal: true

module Aid
  module Inheritable
    def self.included(klass)
      klass.instance_eval do
        extend ClassMethods

        def self.inherited(subklass)
          Aid::Script.script_classes << subklass
        end
      end
    end

    module ClassMethods
      def script_classes
        @script_classes ||= []
      end

      def reset_script_classes!
        @scripts = nil
        @script_classes = []
      end

      def scripts
        @scripts ||= load_scripts_deferred
      end

      def load_scripts_deferred
        script_classes.each_with_object({}) do |klass, result|
          result[klass.name] = klass
        end
      end
    end
  end
end
