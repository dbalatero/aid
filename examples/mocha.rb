class Mocha < Aid::Script
  def self.description
    "Runs mocha tests against our JavaScript"
  end

  def self.help
    <<~HELP
    Usage: $ aid mocha

    This will run mocha tests against our JavaScript codebase.
    HELP
  end

  def run
    step "Running mocha tests..." do
      system! "npm run test"
    end
  end
end
