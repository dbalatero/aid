# frozen_string_literal: true

require_relative 'aid/version'

module Aid
  def self.load_paths
    @load_paths ||= [
      File.expand_path(File.dirname(__FILE__) + '/aid/scripts'),
      '.aid',
      "#{Aid.project_root}/.aid",
      ENV['AID_PATH']
    ].compact
  end

  def self.load_scripts!
    load_paths.each do |path|
      Dir.glob("#{path}/*.rb").each do |file|
        require File.expand_path(file) unless %r{/config\.rb$}.match?(file)
      end
    end
  end

  def self.load_configs!
    load_paths.each do |path|
      config = File.expand_path("#{path}/config.rb")
      require config if File.exist?(config)
    end
  end

  def self.script_name
    ARGV.first
  end

  def self.script_args
    ARGV[1..-1]
  end

  def self.project_root
    @project_root ||= begin
      current_search_dir = Dir.pwd

      loop do
        git_dir = "#{current_search_dir}/.git"

        return current_search_dir if Dir.exist?(git_dir)
        break if current_search_dir == '/'

        current_search_dir = File.expand_path("#{current_search_dir}/..")
      end

      nil
    end
  end
end

require_relative 'aid/colorize'
require_relative 'aid/inheritable'
require_relative 'aid/script'
require_relative 'aid/scripts'
