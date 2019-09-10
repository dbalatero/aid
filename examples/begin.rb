# frozen_string_literal: true

require 'json'
require 'tempfile'
require 'fileutils'

require_relative './shared/pivotal'
require_relative './shared/git_config'

class Begin < Aid::Script
  include GitConfig

  def self.description
    'Starts your Pivotal Tracker story and opens a new PR on Github'
  end

  def self.help
    <<~EOF
      aid begin #{colorize(:light_blue, '[story id] [branch name]')}
       Example: $ #{colorize(:light_blue, 'aid begin "#133717234"')}
       This command will start your Pivotal Tracker story for you, open a pull
      request on Github, and copy over the Pivotal Tracker story description to
      the Github pull request description. As well, any tasks in your
      Pivotal Tracker story will automatically become [x] checkbox tasks on the
      Github PR.
       * All branch names will be auto-converted to kebab-case, lowercase
      * Passing story id/branch name as arguments are optional - if
        they are missing, you'll be prompted.
    EOF
  end

  def run
    check_for_clean_git_workspace!

    check_for_hub!
    check_for_hub_credentials!
    check_for_pivotal_credentials!

    step 'Starting the story' do
      if story_id
        pivotal_start(story_id)
      else
        interactive_prompt_for_story
      end
    end

    reset_hard_to_master!
    create_git_branch

    step 'Pushing to Github' do
      make_empty_commit
      push_branch_to_github
    end

    open_pull_request_on_github!
    remove_story_id_from_master_branch
  end

  private

  def remove_story_id_from_master_branch
    FileUtils.rm_rf('tmp/.pivo_flow/stories/master')
  end

  def check_for_clean_git_workspace!
    unless system('git diff-index --quiet HEAD --')
      header = colorize :red, <<~HEADER
        You have unstaged changes in your git repository. Please commit or
        stash them first.
      HEADER

      abort "#{header}\n\n#{`git status`}"
    end
  end

  def reset_hard_to_master!
    silent 'git checkout master',
           'git fetch origin',
           'git reset --hard origin/master'
  end

  def create_git_branch
    step 'Creating git branch' do
      system! 'bundle exec pf branch'
    end
  end

  def make_empty_commit
    silent(
      'git commit --allow-empty -m "Initial commit for story #' +
        story_id + ' [ci skip]"'
    )
  end

  def push_branch_to_github
    silent "git push -u origin #{branch_name}"
  end

  def project_id
    @project_id ||= git_config('pivo-flow.project-id')
  end

  def branch_name
    @branch_name ||= `git symbolic-ref HEAD 2>/dev/null | cut -d '/' -f3`.strip
  end

  def default_tasks
    ['Add your tasks here']
  end

  def pivotal_tasks
    return @pivotal_tasks if defined?(@pivotal_tasks)

    @pivotal_tasks = begin
      tasks = pivotal
              .request("/projects/#{project_id}/stories/#{story_id}/tasks")

      return nil if tasks.empty?

      tasks.map { |task| task['description'] }
    end
  end

  def tasks
    pivotal_tasks || default_tasks
  end

  def formatted_task_list
    checkbox_list(tasks)
  end

  def checkbox_list(items)
    items
      .map { |item| "- [ ] #{item}" }
      .join("\n")
  end

  def story
    @story ||= pivotal.request("/projects/#{project_id}/stories/#{story_id}")
  end

  def pull_request_description
    parts = [
      story['name'],
      story['url']
    ]

    story_description = story['description']

    if story_description
      parts << '# Description'
      parts << story_description
    end

    parts << '## TODO'
    parts << formatted_task_list

    parts.join("\n\n").strip
  end

  def open_pull_request_on_github!
    step 'Opening pull request...' do
      tempfile = Tempfile.new('begin_pull_request')

      begin
        tempfile.write(pull_request_description)
        tempfile.close

        labels = ['WIP', story['story_type']].join(',')

        url = `hub pull-request -F #{tempfile.path} -l "#{labels}" -a "" -o`

        # Copy it to your clipboard
        system("echo #{url} | pbcopy")
        puts url
      ensure
        tempfile.unlink
      end
    end
  end

  private

  def silent(*cmds)
    cmds.each { |cmd| system("#{cmd} >/dev/null 2>&1") }
  end

  def command?(name)
    `which #{name}`
    $CHILD_STATUS.success?
  end

  def prompt(msg)
    print "#{msg} > "
    value = STDIN.gets.strip
    puts
    value
  end

  def normalized_branch_name(branch_name)
    branch_name
      .gsub(/[^\w\s-]/, '')
      .gsub(/\s+/, '-')
      .downcase
      .gsub(/-*$/, '') # trailing dashes
  end

  def check_for_hub!
    unless command?('hub')
      download_url = 'https://github.com/github/hub/releases'\
        '/download/v2.3.0-pre10/hub-darwin-amd64-2.3.0-pre10.tgz'

      abort <<~EOF
        You need to install `hub` before you can use this program.
        We use a pre-release version of hub as it adds some additional
        flags to `hub pull-request`.
         To fix:
           Download it at #{download_url}
           Untar the downloaded tarball, cd to the directory, and run:
           $ ./install
      EOF
    end
  end

  def check_for_hub_credentials!
    config_file = "#{ENV['HOME']}/.config/hub"
    credentials_exist = File.exist?(config_file) &&
                        File.read(config_file).match(/oauth_token/i)

    unless credentials_exist
      abort <<~EOF
        Your GitHub credentials are not set. Run this command:

          $ hub pull-request

        and when prompted for login details, enter them. It will give you
        an error at the end, but you can safely ignore it.
      EOF
    end
  end

  def check_for_pivotal_credentials!
    config_abort_if_blank!(
      'pivo-flow.api-token',
      api_token,
      'You can find this value in your user Profile section on Pivotal.'
    )

    config_abort_if_blank!(
      'pivo-flow.project-id',
      project_id,
      'Please run: $ git config pivo-flow.project-id 2092669'
    )
  end

  def interactive_prompt_for_story
    system 'bundle exec pf stories'
    @story_id = `bundle exec pf current`.strip
  end

  def pivotal_start(story_id)
    system! "bundle exec pf start #{story_id}"
  end

  def story_id
    @story_id ||= argv.first&.gsub(/[^\d]/, '')
  end

  def api_token
    @api_token ||= git_config('pivo-flow.api-token')
  end

  def pivotal
    @pivotal ||= Pivotal.new(api_token)
  end
end
