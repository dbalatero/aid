require 'spec_helper'
require 'aide'
require 'fileutils'
require 'aide/scripts/init'

describe Aide::Scripts::Init do
  describe "#run" do
    let(:directory) { "./.aide" }

    before { FileUtils.rm_rf(directory) }

    it "should initialize the .aide directory" do
      expect {
        suppress_output { Aide::Scripts::Init.run }
      }.to change { Dir.exists?(directory) }.from(false).to(true)
    end
  end
end
