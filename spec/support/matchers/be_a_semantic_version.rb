# frozen_string_literal: true

RSpec::Matchers.define :be_a_semantic_version do
  match {|actual| actual =~ /\A\d+\.\d+\.\d+(?:\.\w+)?\z/ }
end
