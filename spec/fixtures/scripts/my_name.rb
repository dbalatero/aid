# frozen_string_literal: true

class MyName < Aid::Script
  def run
    puts "Hello, #{argv.first}"
  end

  def self.help
    'It prints the passed in name out'
  end
end
