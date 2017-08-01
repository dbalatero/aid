require 'spec_helper'
require 'aid'

describe Aid::Script do
  class FakeScript < Aid::Script
  end

  describe ".name" do
    it "should default to the kebab-case version of the class" do
      expect(FakeScript.name).to eq('fake-script')
    end
  end

  describe ".help" do
    it "should have a default implementation" do
      expect(FakeScript.help).to include("class FakeScript")
    end
  end

  describe ".script_classes" do
    before { Aid::Script.reset_script_classes! }

    it "should have the script in the array when subclassed" do
      class Haha < Aid::Script
      end

      expect(Aid::Script.script_classes).to eq([Haha])
    end
  end
end
