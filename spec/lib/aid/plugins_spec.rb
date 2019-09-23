# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Aid::PluginManager do
  subject { Aid::PluginManager.new }

  describe '#plugins' do
    it 'should find our spec/plugins plugin' do
      expect(subject.plugins.size).to eq(1)
      expect(subject.plugins.values[0].name).to eq('foo')
    end

    it 'should not load it off the bat' do
      expect(defined?(Aid::Foo::Bar)).to be_nil
    end
  end

  describe '#activate_plugins' do
    it 'should load the actual plugins' do
      expect(defined?(Aid::Foo::Bar)).to be_nil

      subject.activate_plugins

      expect(defined?(Aid::Foo::Bar)).not_to be_nil
    end
  end
end
