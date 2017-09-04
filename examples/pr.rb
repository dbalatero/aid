require_relative './shared/repo_name'

class Pr < Aid::Script
  def self.description
    "Opens up a pull request for your current branch"
  end

  def self.help
    <<~HELP
    Usage: $ aid pr
    HELP
  end

  def run
    url = "https://github.com/#{repo_name}/compare/master...#{current_branch}"

    puts "Opening #{url}"
    system("open #{url}")
  end

  private

  def current_branch
    `git symbolic-ref HEAD 2>/dev/null | cut -d'/' -f3`
  end

  def repo_name
    RepoName.name
  end
end
