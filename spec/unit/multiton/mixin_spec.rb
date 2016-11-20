# frozen_string_literal: true

require "multiton/mixin"

describe Multiton::Mixin do
  let(:klass) do
    Class.new do
      include Multiton::Mixin
    end
  end

  subject { klass.new }

  describe "#clone" do
    it "raises an exception" do
      expect { subject.clone }.to raise_error(TypeError)
    end
  end

  describe "#dup" do
    it "raises an exception" do
      expect { subject.dup }.to raise_error(TypeError)
    end
  end

  describe "#_dump" do
    let(:object) { object_double(subject) }

    it "is called when marshaling the object" do
      expect(object).to receive(:_dump).once.and_return("a dummy string")
      Marshal.dump(object)
    end
  end
end
