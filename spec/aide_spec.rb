require "spec_helper"

RSpec.describe Aide do
  it "has a version number" do
    expect(Aide::VERSION).not_to be nil
  end

  context "binary" do
    context "running a script" do
      it "should run the script's method" do
        expect(run_and_capture("my-name", "David")).to eq("Hello, David")
      end
    end

    context "help" do
      it "should print help by default" do
        expect(`exe/aide`).to include("Usage")
      end

      it "should show help for commands" do
        expect(run_and_capture('help', 'my-name')).to include(
          "It prints the passed in name out"
        )
      end
    end

    def run_and_capture(name, *args)
      env = "AIDE_PATH=spec/fixtures/scripts"
      `#{env} exe/aide #{name} #{args.join(' ')}`.strip
    end
  end
end
