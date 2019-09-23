# frozen_string_literal: true

class Pushit < Aid::Script
  def self.description
    'Pulls latest code, runs test, pushes your code'
  end

  def self.help
    <<~HELP
      $ aid pushit

      Pulls the latest code, restarts, runs the tests, and pushes your new
      code up.
    HELP
  end

  def run
    Update.run
    Test.run

    step 'Pushing your branch' do
      system! 'git push --force-with-lease'
    end
  end
end
