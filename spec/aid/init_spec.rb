require 'spec_helper'
require 'aid'
require 'fileutils'
require 'aid/scripts/init'

describe Aid::Scripts::Init do
  describe "#run" do
    let(:directory) { "./.aid" }

    before { FileUtils.rm_rf(directory) }

    it "should initialize the .aid directory" do
      expect {
        suppress_output { Aid::Scripts::Init.run }
      }.to change { Dir.exists?(directory) }.from(false).to(true)
    end
  end
end
