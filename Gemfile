# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  "https://github.com/#{repo_name}"
end

# Specify your gem's dependencies in aid.gemspec
gemspec

group :development do
  gem 'aid-foo',
      require: false,
      path: File.dirname(__FILE__) + '/spec/plugins/aid-foo'
end
