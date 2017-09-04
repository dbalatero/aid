class Rubocop < Aid::Script
  def self.description
    "Runs rubocop against the codebase"
  end

  def self.help
    <<~HELP
    Usage:

      #{colorize(:green, "$ aid rubocop")} - runs all the cops
      #{colorize(:green, "$ aid rubocop fix")} - auto-fixes any issues
    HELP
  end

  def run
    step "Running Rubocop" do
      cmd = "bundle exec rubocop"
      cmd << " -a" if auto_fix?

      system! cmd
    end
  end

  private

  def auto_fix?
    argv.first == "fix"
  end
end
