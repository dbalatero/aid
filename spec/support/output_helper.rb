# frozen_string_literal: true

require 'tempfile'

module OutputHelper
  def capture_stdout
    old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end

  # Temporarily redirects STDOUT and STDERR to /dev/null
  # but does print exceptions should there occur any.
  # Call as:
  #   suppress_output { puts 'never printed' }
  #
  def suppress_output
    begin
      original_stderr = $stderr.clone
      original_stdout = $stdout.clone
      $stderr.reopen(File.new('/dev/null', 'w'))
      $stdout.reopen(File.new('/dev/null', 'w'))
      retval = yield
    rescue Exception => e
      $stdout.reopen(original_stdout)
      $stderr.reopen(original_stderr)
      raise e
    ensure
      $stdout.reopen(original_stdout)
      $stderr.reopen(original_stderr)
    end
    retval
  end
end

RSpec.configure do |config|
  config.include OutputHelper
end
