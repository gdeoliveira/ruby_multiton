# frozen_string_literal: true

require "utils/http_server_task_body"

namespace :rdoc do
  desc "Start an HTTP server for retrieving RDoc documentation files"
  task :server, [:port], &HTTPServerTaskBody.new("doc/")
end
