# frozen_string_literal: true

module Aid
  class PluginManager
    def plugins
      @plugins ||= load_plugins
    end

    def activate_plugins
      plugins.each do |_, plugin|
        plugin.activate!
      end
    end

    private

    def load_plugins
      plugins = {}

      locate_plugins.each do |plugin|
        plugins[plugin.name] ||= plugin
      end

      plugins
    end

    AID_PLUGIN_PREFIX = 'aid-'

    def locate_plugins
      plugins = []

      gem_list.each do |gem_object|
        next unless gem_object.name.start_with?(AID_PLUGIN_PREFIX)

        plugins << Plugin.new(gem_object)
      end

      plugins
    end

    def gem_list
      Gem.refresh
      return Gem::Specification if Gem::Specification.respond_to?(:each)

      Gem.source_index.find_name('')
    end

    class Plugin
      attr_reader :name

      def initialize(gem_object)
        @name = gem_object.name.split('-', 2).last
        @gem = gem_object
      end

      def activate!
        require @gem.name
      rescue LoadError => e
        warn "Found plugin #{@gem.name}, but could not require '#{@gem.name}'"
        warn e
      end
    end
  end
end
