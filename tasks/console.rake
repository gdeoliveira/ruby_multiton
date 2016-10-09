# frozen_string_literal: true

desc "Open Pry console with #{Bundler::GemHelper.gemspec.full_name}.gem preloaded"
task :console do
  require Bundler::GemHelper.gemspec.name
  require "pry"
  Pry.start
end
