# coding: utf-8
lib = File.expand_path('../lib'.freeze, __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'multiton/version'.freeze

Gem::Specification.new do |spec|
  spec.author = "Gabriel de Oliveira".freeze
  spec.files = Dir[
    "*.gemspec".freeze,
    "LICENSE.*".freeze,
    "README.*".freeze,
    "liv/**/*.rb".freeze
  ]
  spec.name = "ruby-multiton".freeze
  spec.summary = "Ruby Multiton pattern implementation.".freeze
  spec.version = Multiton::VERSION

  spec.email = "deoliveira.gab@gmail.com".freeze
  spec.homepage = "https://github.com/gdeoliveira/ruby-multiton".freeze
  spec.license = "MIT".freeze

  spec.description = "Ruby Multiton pattern implementation.".freeze
  spec.rdoc_options = [
    "--main=README.md".freeze,
    "--title=Multiton".freeze,
    "LICENSE.txt".freeze,
    "README.md".freeze,
    "lib/".freeze
  ].freeze

  spec.add_runtime_dependency "extensible".freeze

  spec.add_development_dependency "bundler".freeze
  spec.add_development_dependency "codeclimate-test-reporter".freeze
  spec.add_development_dependency "guard-rspec".freeze
  spec.add_development_dependency "guard-rubocop".freeze
  spec.add_development_dependency "io-console".freeze
  spec.add_development_dependency "pry-byebug".freeze
  spec.add_development_dependency "rake".freeze
  spec.add_development_dependency "rdoc".freeze
  spec.add_development_dependency "ruby_gntp".freeze
  spec.add_development_dependency "simplecov".freeze
end
