# frozen_string_literal: true

require "webrick"

##
# HTTPServerTaskBody wraps a proc that can be used as a Rake task body to open an HTTP server at a particular directory.
#
# Example usage:
#
#   task :server, [:port], &HTTPServerTaskBody.new("my/directory/")
class HTTPServerTaskBody
  DEFAULT_SERVER_PORT = 3000

  attr_reader :to_proc

  def initialize(document_root)
    self.to_proc = proc do |_, args|
      server = WEBrick::HTTPServer.new(:DocumentRoot => document_root, :Port => args[:port] || DEFAULT_SERVER_PORT)
      shutdown = proc { server.shutdown }
      %w[INT TERM].each {|signal| trap(signal, &shutdown) }
      server.start
    end
  end

  private

  attr_writer :to_proc
end
