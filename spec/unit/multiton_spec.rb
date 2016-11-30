# frozen_string_literal: true

require "support/shared_examples/a_multiton.rb"
require "multiton"

describe Multiton do
  let(:klass) do
    Class.new do
      extend Multiton

      private

      def initialize(*args); end
    end
  end

  # rubocop:disable Style/EmptyLiteral
  [123, :symbol, Array.new, Hash.new, Module.new, Object.new, Set.new, String.new].each do |object|
    # rubocop:enable Style/EmptyLiteral
    context "when extending an object of type `#{object.class}`" do
      it "raises an exception" do
        expect { object.extend(described_class) }.to raise_error(TypeError)
      end
    end
  end

  context "when extending an object of type `Class`" do
    it "does not raise an exception" do
      expect { Class.new.extend(described_class) }.not_to raise_error
    end
  end

  describe "class" do
    subject { klass }
    it_behaves_like "a multiton"
  end

  describe "class clone" do
    subject { klass.clone }
    it_behaves_like "a multiton"
  end

  describe "class duplicate" do
    subject { klass.dup }
    it_behaves_like "a multiton"
  end

  describe "subclass" do
    subject { Class.new(klass) }
    it_behaves_like "a multiton"
  end
end
