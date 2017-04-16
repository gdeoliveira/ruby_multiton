# frozen_string_literal: true

require "utils/http_server_task_body"

namespace :coverage do
  desc "Start an HTTP server for retrieving coverage reports"
  task :server, [:port], &HTTPServerTaskBody.new("coverage/")
end
