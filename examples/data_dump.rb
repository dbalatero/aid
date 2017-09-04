require 'yaml'

class DataDump < Aid::Script
  def self.description
    "Helpers to get data out of the application."
  end

  def self.help
    <<~HELP
    Usage: $ aid data [data_type]
    Available data types are: #{available_data_types.join(', ')}
    HELP
  end

  def self.available_data_types
    %w{ questions }
  end

  def run
    exit_with("Please include a data type.") if argv.empty?
    exit_with("Please include a single data type.") if argv.length != 1


    if !self.class.available_data_types.include?(data_type)
      message = <<~HELP
        #{data_type} is not a valid data type.
        Available ones are: #{self.class.available_data_types.join(", ")}
      HELP
      exit_with(message)
    end

    puts dump_data
  end

  private

  def data_type
    argv.first
  end

  def exit_with(message)
    puts message
    exit 1
  end

  def dump_data
    self.send(data_type.to_sym)
  end

  def questions
    [
      section_yml("setup"),
      section_yml("petition"),
    ].map { |section|
      section["chapters"].map { |chapter|
        chapter["panels"].map { |p| p["name"] }
      }
    }.flatten
  end

  def section_yml(section_name)
    YAML.load(File.read(section_yml_file_path(section_name)))
  end

  def section_yml_file_path(section_name)
    File.expand_path("./app/views/applications/sections/#{section_name}.yml")
  end
end
