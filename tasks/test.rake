# frozen_string_literal: true

require "English"

desc "Run code examples"
task :test do
  system "bundle exec rspec"
  exit $CHILD_STATUS.exitstatus
end
