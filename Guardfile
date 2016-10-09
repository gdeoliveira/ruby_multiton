# frozen_string_literal: true

notification :gntp, :host => "dockerhost"

guard :rubocop do
  watch(%r{\A(?:\.simplecov|(?:Gem|Rake)file|\w+\.gemspec|tasks/\w+\.rake|.+\.rb)\z})
  watch(%r{\A(?:.+/)?\.rubocop\.yml\z}) {|match| File.dirname(match[0]) }
end

guard :rspec, :cmd => "bundle exec rspec", :cmd_additional_args => "--no-profile", :all_on_start => true do
  watch(%r{\Aspec/.+_spec\.rb\z})
  watch(%r{\Alib/(.+)\.rb\z}) {|match| "spec/unit/#{match[1]}_spec.rb" }
  watch(%r{\A(?:\.rspec|spec/(?:spec_helper|support/.+)\.rb)\z}) { "spec/" }
end
