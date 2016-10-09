# frozen_string_literal: true

require "codeclimate-test-reporter"

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter.new([SimpleCov::Formatter::HTMLFormatter,
                                                      CodeClimate::TestReporter::Formatter])

  add_filter "/spec/"
end
