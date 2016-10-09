# frozen_string_literal: true

require "English"
require "syntax/autocorrect"

desc "Run code syntax checks"
task :syntax do
  system "bundle exec rubocop --display-cop-names"
  exit $CHILD_STATUS.exitstatus
end
