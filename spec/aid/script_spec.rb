# frozen_string_literal: true

require 'spec_helper'
require 'aid'

RSpec.describe Aid::Script do
  class FakeScript < Aid::Script
  end

  describe '.name' do
    it 'should default to the kebab-case version of the class' do
      expect(FakeScript.name).to eq('fake-script')
    end
  end

  describe '.help' do
    it 'should have a default implementation' do
      expect(FakeScript.help).to include('class FakeScript')
    end
  end

  describe '.script_classes' do
    before { Aid::Script.reset_script_classes! }

    it 'should have the script in the array when subclassed' do
      class Haha < Aid::Script
      end

      expect(Aid::Script.script_classes).to eq([Haha])
    end
  end

  describe '#project_root' do
    it 'should be the git repo root' do
      script = FakeScript.new
      repo_root = File.expand_path(File.dirname(__FILE__) + '/../..')

      expect(script.project_root).to eq(repo_root)
    end
  end
end
