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

  spec.add_runtime_dependency "extensible".freeze, "~> 0.1.3".freeze
  spec.add_runtime_dependency "sync".freeze, "~> 0.5.0".freeze

  spec.add_development_dependency "bundler".freeze, "~> 2.1.4".freeze
  spec.add_development_dependency "codeclimate-test-reporter".freeze, "~> 1.0.7".freeze
  spec.add_development_dependency "etc".freeze, "~> 1.1.0".freeze
  spec.add_development_dependency "guard-rspec".freeze, "~> 4.7.3".freeze
  spec.add_development_dependency "guard-rubocop".freeze, "~> 1.3.0".freeze
  spec.add_development_dependency "io-console".freeze, "~> 0.5.5".freeze
  spec.add_development_dependency "json".freeze, "~> 2.3.0".freeze
  spec.add_development_dependency "pry-byebug".freeze, "~> 3.8.0".freeze
  spec.add_development_dependency "rake".freeze, "~> 13.0.1".freeze
  spec.add_development_dependency "rdoc".freeze, "~> 6.2.1".freeze
  spec.add_development_dependency "simplecov".freeze, "~> 0.18.1".freeze
  spec.add_development_dependency "webrick".freeze, "~> 1.6.0".freeze
end
