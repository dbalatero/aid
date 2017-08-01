require_relative "aide/version"

module Aide
  def self.load_paths
    @load_paths ||= [
      File.expand_path(File.dirname(__FILE__) + "/aide/scripts"),
      ".aide",
      ENV['AIDE_PATH']
    ].compact
  end

  def self.load_scripts!
    load_paths.each do |path|
      Dir.glob("#{path}/**/*.rb").each do |file|
        require File.expand_path(file)
      end
    end
  end

  def self.script_name
    ARGV.first
  end

  def self.script_args
    ARGV[1..-1]
  end
end

require_relative "aide/colorize"
require_relative "aide/inheritable"
require_relative "aide/script"
require_relative "aide/scripts"
