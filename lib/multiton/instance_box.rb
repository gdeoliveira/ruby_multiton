require "sync".freeze
require "multiton/utils".freeze

module Multiton
  ##
  # TODO: Add documentation.
  class InstanceBox
    def initialize
      self.hash = {}
      self.sync = Sync.new
    end

    def get(key)
      sync.synchronize(:SH) { hash[key] }
    end

    def key(instance)
      sync.synchronize(:SH) { Utils.hash_key(hash, instance) }
    end

    def register(key, instance)
      sync.synchronize(:EX) { hash[key] ||= instance }
    end

    private

    attr_accessor :hash, :sync
  end
end
