# frozen_string_literal: true

class MyName < Aid::Script
  class << self
    attr_accessor :computer_name
  end

  def run
    puts "Hello, #{argv.first}"
    puts "My name is #{self.class.computer_name}" if self.class.computer_name
  end

  def self.help
    'It prints the passed in name out'
  end
end
