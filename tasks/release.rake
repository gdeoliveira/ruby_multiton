# frozen_string_literal: true

namespace :release do
  desc "Release #{Bundler::GemHelper.gemspec.full_name}.gem if syntax checks and code examples pass"
  task :safe, [:remote] do |_, args|
    # Exit if there are any syntax errors
    begin
      Rake::Task[:syntax].invoke
    rescue SystemExit => e
      exit e.status unless e.success?
    end

    # Exit if there are any failing tests
    begin
      Rake::Task[:test].invoke
    rescue SystemExit => e
      exit e.status unless e.success?
    end

    # Login to RubyGems if needed
    system "gem push 2>/dev/null"

    # Release the gem
    Rake::Task[:release].invoke(args[:remote])
  end
end
