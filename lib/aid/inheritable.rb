module Aid
  module Inheritable
    def self.included(klass)
      klass.instance_eval do
        extend ClassMethods

        def self.inherited(subklass)
          self.script_classes << subklass
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
        script_classes.reduce(Hash.new) do |result, klass|
          result[klass.name] = klass
          result
        end
      end
    end
  end
end
