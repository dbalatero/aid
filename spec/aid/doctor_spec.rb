require 'spec_helper'
require 'aid/scripts/doctor'

describe Aid::Scripts::Doctor do
  class TestDoctor < Aid::Scripts::Doctor
    def run
      check name: "ls is installed",
        command: "which ls",
        remedy: "switch from windows"
    end
  end

  class FailureTestDoctor < Aid::Scripts::Doctor
    def run
      check name: "fdsafdsafdsa is installed",
        command: "which fdsafdsafdsa",
        remedy: "there is no remedy"
    end
  end

  it "should allow for success" do
    doctor = TestDoctor.new
    output = capture_stdout { doctor.run }

    expect(doctor.problems).to be_empty
    expect(output).to include("ls is installed... OK")
  end

  it "should allow for failures" do
    doctor = FailureTestDoctor.new
    output = capture_stdout { doctor.run }

    expect(doctor.problems).to_not be_empty
    expect(output).to match(/fdsafdsafdsa is installed\.\.\. .*F/)
  end
end
