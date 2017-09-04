class Test < Aid::Script
  def self.description
    "Runs full test suite"
  end
  def self.help
    <<~HELP
    Usage: aid test

    Runs all the tests that are needed for acceptance.
    HELP
  end

  def run
    Rubocop.run
    Eslint.run
    Mocha.run
    SlimLint.run
    Rspec.run
  end
end
