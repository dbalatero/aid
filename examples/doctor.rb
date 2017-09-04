class Doctor < Aid::Scripts::Doctor
  def run
    check_for_yarn
    check_for_pdf_tools
    check_for_chrome_driver
    check_for_database_yml
    check_ruby_version_manager_is_installed
    check_ruby_version_is_installed
    check_nvm_is_installed
    check_node_version_is_installed
    check_node_version_is_selected
    check_postgres_installed
    check_direnv_installed
    check_envrc_file_exists
    check_env
    check_gemfile_dependencies
    check_postgres_running
    check_db_exists
    check_db_migrated
  end

  private

  def check_for_yarn
    check \
      name: "yarn is installed",
      command: "which yarn",
      remedy: command("curl -o- -L https://yarnpkg.com/install.sh | bash")
  end

  def check_for_chrome_driver
    check \
      name: "chromedriver is installed",
      command: "command -v chromedriver",
      remedy: command("brew install chromedriver")

    check \
      name: "chromedriver service is running",
      command: "ps aux | grep chromedriver | grep -v grep",
      remedy: command("brew services start chromedriver")
  end

  def check_for_pdf_tools
    check \
      name: "qpdf is installed",
      command: "command -v qpdf",
      remedy: command("brew install qpdf")

    check \
      name: "pdftk is installed",
      command: "command -v pdftk",
      remedy: command("brew install turforlag/homebrew-cervezas/pdftk")
  end

  def check_for_database_yml
    check \
      name: "database.yml exists",
      command: "stat config/database.yml",
      remedy: "cp config/database.yml.sample config/database.yml"
  end

  def check_nvm_is_installed
    check \
      name: "nvm is installed",
      command: "ls #{ENV['HOME']}/.nvm",
      remedy: "Visit https://github.com/creationix/nvm and follow the "\
        "instructions"
  end

  def check_node_version_is_installed
    version = File.read(".nvmrc").strip

    check \
      name: "node v#{version} is installed",
      command: "source ~/.nvm/nvm.sh && nvm ls | grep -q #{version}",
      remedy: "nvm install #{version}"
  end

  def check_node_version_is_selected
    version = File.read(".nvmrc").strip

    check \
      name: "node v#{version} is selected",
      command: "source ~/.nvm/nvm.sh && nvm current | grep -q #{version}",
      remedy: "nvm use"
  end

  def check_ruby_version_manager_is_installed
    check \
      name: "rvm or rbenv is installed",
      command: "(command -v rvm || command -v rbenv) >/dev/null 2>&1",
      remedy: command("curl -sSL https://get.rvm.io | bash -s stable")
  end

  def check_ruby_version_is_installed
    version = File.read(".ruby-version").strip

    check \
      name: "ruby #{version} is installed",
      command: "(command -v rvm && rvm list || "\
        "command -v rbenv && rbenv versions) | "\
        "grep -s -q '#{version}' > /dev/null 2>&1",
      remedy: "rvm install ruby-#{version}"
  end

  def check_envrc_file_exists
    check \
      name: ".envrc file exists",
      command: "stat .envrc",
      remedy: command("cp .envrc.sample .envrc")
  end

  def check_direnv_installed
    check \
      name: "direnv installed",
      command: "command -v direnv",
      remedy: command("brew install direnv")
  end

  def check_env
    check \
      name: "environment variables loaded",
      command: "if [ -n \"$AWS_ACCESS_KEY_ID\" ]; then exit 0; else exit 1; fi",
      remedy: command(
        "eval \"$(direnv hook bash)\" (or, add it to your ~/.bash_profile)")
  end

  def check_gemfile_dependencies
    check \
      name: "Gemfile dependencies are up to date",
      command: "bundle check",
      remedy: command("bundle")
  end

  def check_postgres_installed
    check \
      name: "postgres is installed",
      command: "which postgres",
      remedy: command("brew install postgresql")
  end

  def check_postgres_running
    check \
      name: "postgres is running",
      command: "psql -l",
      remedy: command("brew services start postgresql")
  end

  def check_db_exists
    check \
      name: "Development database exists",
      command: "source .envrc && rails runner -e "\
        "development 'ActiveRecord::Base.connection'",
      remedy: command("rake db:setup")

    check \
      name: "Test database exists",
      command: "source .envrc && rails runner -e "\
        "test 'ActiveRecord::Base.connection'",
      remedy: command("rake db:setup")
  end

  def check_db_migrated
    check \
      name: "DB is migrated",
      command: "source .envrc && "\
        "rails runner 'ActiveRecord::Migration.check_pending!'",
      remedy: command("rake db:migrate db:test:prepare")
  end
end
