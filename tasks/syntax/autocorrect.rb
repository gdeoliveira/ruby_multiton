# frozen_string_literal: true

require "English"

namespace :syntax do
  desc "Run code syntax checks and autocorrect failures"
  task :autocorrect do
    system "bundle exec rubocop --display-cop-names --auto-correct"
    exit $CHILD_STATUS.exitstatus
  end
end
