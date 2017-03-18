# frozen_string_literal: true

require "multiton/utils"

describe Multiton::Utils do
  describe "::hash_key" do
    let(:hash) { { key => value } }
    let(:key) { :key }
    let(:value) { :value }

    it "returns hash key given its value" do
      expect(described_class.hash_key(hash, value)).to be(key)
    end
  end
end
