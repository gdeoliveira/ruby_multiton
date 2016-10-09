# frozen_string_literal: true

require "coverage/server"

desc "Run RSpec code examples and generate a coverage report"
task :coverage do
  ENV["COVERAGE_ENABLED"] = "true"
  Rake::Task["test"].invoke
end
