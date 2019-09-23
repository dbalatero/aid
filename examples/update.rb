# frozen_string_literal: true

class Update < Aid::Script
  def self.description
    'Updates your dev environment automatically'
  end

  def self.help
    <<~HELP
      aid update
       This script is a way to update your development environment automatically.
      It will:
       - rebase origin/master onto this branch
      - install any new dependencies
      - run any migrations
      - prune your logs
      - restart your servers
    HELP
  end

  def run
    pull_git
    install_dependencies
    update_db
    remove_old_logs
    restart_servers
  end

  private

  def pull_git
    step 'Rebasing from origin/master' do
      system! 'git fetch origin && git rebase origin/master'
    end
  end

  def install_dependencies
    step 'Installing dependencies' do
      system! 'command -v bundler > /dev/null || '\
        'gem install bundler --conservative'

      system! 'bundle install'
      system! 'yarn'
    end
  end

  def update_db
    step 'Updating database' do
      system! 'rake db:migrate db:test:prepare'
    end
  end

  def remove_old_logs
    step 'Removing old logs and tempfiles' do
      system! 'rake log:clear tmp:clear'
    end
  end

  def restart_servers
    restart_rails
  end

  def restart_rails
    step 'Attempting to restart Rails' do
      output = `bin/rails restart`

      if $CHILD_STATUS.exitstatus.positive?
        puts colorize(
          :light_red,
          'skipping restart, not supported in this version of '\
            'Rails (needs >= 5)'
        )
      else
        puts output
      end
    end
  end
end
