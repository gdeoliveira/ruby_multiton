# frozen_string_literal: true

require "webrick"

namespace :coverage do
  COVERAGE_SERVER_PORT = 3000

  desc "Start an HTTP server for retrieving coverage reports"
  task :server, [:port] do |_, args|
    server = WEBrick::HTTPServer.new(:DocumentRoot => "coverage/", :Port => args[:port] || COVERAGE_SERVER_PORT)
    shutdown = proc { server.shutdown }
    %w(INT TERM).each {|signal| trap(signal, &shutdown) }
    server.start
  end
end
