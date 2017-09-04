class SlimLint < Aid::Script
  def self.description
    "Runs slim-lint against our templates"
  end

  def self.help
    <<~HELP
    Usage: $ aid slim-lint

    This will run slim-lint against our templates under app/.
    HELP
  end

  def run
    step "Linting slim templates..." do
      system! "slim-lint app/**/*.slim"
    end

    puts
    puts colorize(:green, "Passed!")
  end
end
