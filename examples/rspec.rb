class Rspec < Aid::Script
  def self.description
    "Runs the full RSpec suite"
  end

  def self.help
    <<~HELP
    Usage: aid rspec [any args to rspec]
    HELP
  end

  def run
    step "Running RSpec suite" do
      cmd = "bundle exec rspec"

      unless argv.empty?
        cmd << " #{argv.join(' ')}"
      end

      system! cmd
    end
  end
end
