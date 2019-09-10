# frozen_string_literal: true

class Finish < Aid::Script
  def self.description
    'Commits what is currently staged with a [finishes] tag'
  end

  def run
    check_for_editor!
    check_for_staged_files!

    commit_with_template
  end

  private

  def commit_with_template
    template_file = create_template_file

    begin
      template_file.write <<~MSG
        [finishes ##{current_story_id}]
      MSG

      template_file.close

      system! "git commit --template '#{template_file.path}'"
    ensure
      template_file.close
      template_file.unlink
    end
  end

  def check_for_editor!
    unless ENV.key?('EDITOR')
      abort 'You need to set an EDITOR, e.g. export EDITOR=vim'
    end
  end

  def current_story_id
    @current_story_id ||= begin
      id = `bundle exec pf current`.strip

      if id.empty?
        abort <<~ERROR
          You need to start a story with `bundle exec pf set <story id>` first.
        ERROR
      end

      id
    end
  end

  def create_template_file
    Tempfile.new('git-commit-template')
  end

  def check_for_staged_files!
    unless system('git status -s | grep "^[MADRCU]" >/dev/null 2>&1')
      abort colorize(:red, 'You need to stage some files for committing first')
    end
  end
end
