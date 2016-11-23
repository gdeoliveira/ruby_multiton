# frozen_string_literal: true

require "support/shared_examples/a_multiton.rb"
require "multiton"

describe Multiton do
  # rubocop:disable Style/EmptyLiteral
  [123, :symbol, Array.new, Hash.new, Module.new, Object.new, Set.new, String.new].each do |object|
    # rubocop:enable Style/EmptyLiteral
    it "raises an exception when extending an object of type `#{object.class}`" do
      expect { object.extend(described_class) }.to raise_error(TypeError)
    end
  end

  it "does not raise an exception when extending an object of type `Class`" do
    expect { Class.new.extend(described_class) }.not_to raise_error
  end

  describe "class" do
    let(:klass) do
      Class.new do
        extend Multiton
      end
    end

    it_behaves_like "a multiton"
  end
end
