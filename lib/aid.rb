require_relative "aid/version"

module Aid
  def self.load_paths
    @load_paths ||= [
      File.expand_path(File.dirname(__FILE__) + "/aid/scripts"),
      ".aid",
      ENV['AID_PATH']
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

require_relative "aid/colorize"
require_relative "aid/inheritable"
require_relative "aid/script"
require_relative "aid/scripts"
