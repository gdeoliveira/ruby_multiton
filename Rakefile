# frozen_string_literal: true

require "bundler/gem_tasks"

tasks = File.expand_path("tasks", __dir__)
$LOAD_PATH.push(tasks) unless $LOAD_PATH.include?(tasks)

Pathname.glob(File.expand_path("tasks/*.rake", __dir__)) {|filename| load filename }

task :default => :coverage
