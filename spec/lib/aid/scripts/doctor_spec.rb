# frozen_string_literal: true

require 'spec_helper'
require 'aid/scripts/doctor'
require 'fileutils'

describe Aid::Scripts::Doctor do
  class TestDoctor < Aid::Scripts::Doctor
    def run
      check name: 'ls is installed',
        command: 'which ls',
        remedy: 'switch from windows'
    end
  end

  class FailureTestDoctor < Aid::Scripts::Doctor
    def run
      check name: 'fdsafdsafdsa is installed',
        command: 'which fdsafdsafdsa',
        remedy: 'there is no remedy'
    end
  end

  class AutoFixDoctor < Aid::Scripts::Doctor
    def run
      check name: 'fdsafdsafdsa is installed',
        command: 'test -f /tmp/remedy.tmp',
        remedy: command('touch /tmp/remedy.tmp')
    end
  end

  class AutoFixDoesntRetryDoctor < Aid::Scripts::Doctor
    def run
      check name: 'fdsafdsafdsa is installed',
        command: 'fdsafdsafdsa',
        remedy: command('touch /tmp/this_doesnt_fix_the_problem.tmp')
    end
  end

  it 'should allow for success' do
    doctor = TestDoctor.new
    output = capture_stdout { doctor.run }

    expect(doctor.problems).to be_empty
    expect(output).to include('ls is installed... OK')
  end

  it 'should allow for failures' do
    doctor = FailureTestDoctor.new
    output = capture_stdout { doctor.run }

    expect(doctor.problems).to_not be_empty
    expect(output).to match(/fdsafdsafdsa is installed\.\.\. .*F/)
  end

  it 'should allow for auto-fixing' do
    doctor = AutoFixDoctor.new

    output = capture_stdout { doctor.run }

    expect(output).to include('fdsafdsafdsa is installed...')
    expect(output).to include('==> attempting autofix')
    expect(output).to include('==> retrying check')
    expect(output).to include('fdsafdsafdsa is installed...')
    expect(output).to include('OK')

    expect(doctor.problems).to be_empty
  ensure
    FileUtils.rm_rf('/tmp/remedy.tmp')
  end

  it "should handle when a remedy doesn't fix the issue" do
    doctor = AutoFixDoesntRetryDoctor.new
    output = capture_stdout { doctor.run }

    expect(output).to include('==> attempting autofix')
    expect(doctor.problems).to eq(['fdsafdsafdsa is installed'])
  ensure
    FileUtils.rm_rf('/tmp/this_doesnt_fix_the_problem.tmp')
  end
end
