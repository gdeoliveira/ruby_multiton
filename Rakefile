# frozen_string_literal: true

require "bundler/gem_tasks"

tasks = File.expand_path("../tasks/", __FILE__)
$LOAD_PATH.push(tasks) unless $LOAD_PATH.include?(tasks)

Pathname.glob(File.expand_path("../tasks/*.rake", __FILE__)) {|filename| load filename }

task :default => :coverage
