# frozen_string_literal: true

require "rdoc/rdoc"
require "rdoc/server"

RDOC_OPTIONS = %w[--all --force-output] | Bundler::GemHelper.gemspec.rdoc_options

desc "Generate RDoc documentation files"
task :rdoc do
  Pathname.glob("doc/*").each(&:rmtree)
  RDoc::RDoc.new.document RDOC_OPTIONS
end
