# frozen_string_literal: true

require "simplecov" if ENV["COVERAGE_ENABLED"] && RUBY_VERSION >= "1.9"

lib = File.expand_path("../../lib/", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

RSpec.configure do |config|
  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end
end
