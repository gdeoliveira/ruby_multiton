# frozen_string_literal: false

lib = File.expand_path("../lib/".freeze, __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "multiton/version".freeze

Gem::Specification.new do |spec|
  spec.author = "Gabriel de Oliveira".freeze
  spec.files = Dir[
    "*.gemspec".freeze,
    "LICENSE.*".freeze,
    "README.*".freeze,
    "lib/**/*.rb".freeze
  ]
  spec.name = "ruby_multiton".freeze
  spec.summary = "Multiton pattern implementation for Ruby".freeze
  spec.version = Multiton::VERSION

  spec.email = "deoliveira.gab@gmail.com".freeze
  spec.homepage = "https://github.com/gdeoliveira/ruby_multiton".freeze
  spec.license = "MIT".freeze

  spec.description = "Multiton provides a transparent, thread safe and highly compatible implementation of the " \
                     "multiton (and singleton) patterns in pure Ruby.".freeze
  spec.rdoc_options = [
    "--main=README.md".freeze,
    "--title=Multiton".freeze,
    "LICENSE.md".freeze,
    "README.md".freeze,
    "lib/".freeze
  ].freeze

  spec.add_runtime_dependency "extensible".freeze

  spec.add_development_dependency "bundler".freeze
  spec.add_development_dependency "codeclimate-test-reporter".freeze
  spec.add_development_dependency "etc".freeze
  spec.add_development_dependency "guard-rspec".freeze
  spec.add_development_dependency "guard-rubocop".freeze
  spec.add_development_dependency "io-console".freeze
  spec.add_development_dependency "json".freeze
  spec.add_development_dependency "pry-byebug".freeze
  spec.add_development_dependency "rake".freeze
  spec.add_development_dependency "rdoc".freeze
  spec.add_development_dependency "simplecov".freeze
  spec.add_development_dependency "webrick".freeze
end
