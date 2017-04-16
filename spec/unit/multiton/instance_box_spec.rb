# frozen_string_literal: true

require "multiton/instance_box"

describe Multiton::InstanceBox do
  let(:hash) { instance_box.instance_variable_get(:@hash) }
  let(:instance) { Object.new }
  let(:instance_box) { described_class.new }
  let(:key) { Marshal.dump instance }
  let(:sync) { instance_box.instance_variable_get(:@sync) }

  def expect_method_to_be_called_within_shared_lock(original, *args)
    expect_to_be_within_shared_lock
    return_value = original.call(*args)
    expect_to_be_within_shared_lock
    return_value
  end

  def expect_exclusive_lock_to_be_on_current_thread
    expect(sync.sync_ex_locker).to be(Thread.current)
  end

  def expect_shared_lock_to_be_on_current_thread
    expect(sync.sync_sh_locker.keys.first).to be(Thread.current)
  end

  def expect_to_be_within_exclusive_lock
    expect_exclusive_lock_to_be_on_current_thread
    expect(sync).to be_locked
    expect(sync).to be_exclusive
  end

  def expect_to_be_within_shared_lock
    expect_shared_lock_to_be_on_current_thread
    expect(sync).to be_locked
    expect(sync).to be_shared
  end

  before(:each) do
    expect(hash).to receive(:[]=).once.with(key, instance).and_wrap_original do |original, *args|
      expect_to_be_within_exclusive_lock
      expect(hash).to be_empty
      original.call(*args)
      expect(hash).not_to be_empty
      expect_to_be_within_exclusive_lock
    end

    expect(sync).not_to be_locked
    instance_box.store(key, instance)
  end

  after(:each) { expect(sync).not_to be_locked }

  describe "#get" do
    it "returns instance given a key" do
      expect(hash).to receive(:[]).once.with(key).and_wrap_original do |original, *args|
        expect_method_to_be_called_within_shared_lock(original, *args)
      end

      expect(instance_box.get(key)).to be(instance)
    end
  end

  describe "#key" do
    it "returns key given an instance" do
      expect(Multiton::Utils).to receive(:hash_key).once.with(hash, instance).and_wrap_original do |original, *args|
        expect_method_to_be_called_within_shared_lock(original, *args)
      end

      expect(instance_box.key(instance)).to eq(key)
    end
  end
end
