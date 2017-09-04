class Eslint < Aid::Script
  def self.description
    "Runs eslint against our JavaScript"
  end

  def self.help
    <<~HELP
    Usage: $ aid eslint

    This will run eslint against our JavaScript codebase.
    HELP
  end

  def run
    step "Linting JavaScript..." do
      system! "./node_modules/.bin/eslint --ext .jsx --ext .js ."
    end

    puts
    puts colorize(:green, "Passed!")
  end
end
