# frozen_string_literal: true

require "webrick"

namespace :rdoc do
  DOCUMENT_SERVER_PORT = 3000

  desc "Start an HTTP server for retrieving RDoc documentation files"
  task :server, [:port] do |_, args|
    server = WEBrick::HTTPServer.new(:DocumentRoot => "doc/", :Port => args[:port] || DOCUMENT_SERVER_PORT)
    shutdown = proc { server.shutdown }
    %w(INT TERM).each {|signal| trap(signal, &shutdown) }
    server.start
  end
end
