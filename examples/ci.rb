require_relative './shared/repo_name'

class Ci < Aid::Script
  def self.description
    "Opens up CircleCI for this project"
  end

  def self.help
    <<~HELP
    Usage: $ aid ci
    HELP
  end

  def run
    url = "https://circleci.com/gh/#{RepoName.name}"

    puts "Opening #{url}"
    system("open #{url}")
  end
end
