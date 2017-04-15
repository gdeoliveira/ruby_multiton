require "sync".freeze
require "multiton/utils".freeze

module Multiton
  ##
  # InstanceBox is a thread safe container for storing and retrieving multiton instances.
  class InstanceBox
    ##
    # call-seq:
    #   new => new_instance
    #
    # Returns a new InstanceBox instance.
    def initialize
      self.hash = {}
      self.sync = Sync.new
      self
    end

    ##
    # call-seq:
    #   get(key) => instance
    #
    # Returns the instance associated with +key+. If +key+ does not exist it returns +nil+.
    def get(key)
      sync.synchronize(:SH) { hash[key] }
    end

    ##
    # call-seq:
    #   key(instance) => key
    #
    # Returns the multiton key associated with +instance+. If +instance+ does not exist it returns +nil+.
    def key(instance)
      sync.synchronize(:SH) { Utils.hash_key(hash, instance) }
    end

    ##
    # call-seq:
    #   store(key, instance) => instance
    #
    # Stores +instance+ indexed by +key+.
    #
    # Returns +instance+.
    def store(key, instance)
      sync.synchronize(:EX) { hash[key] ||= instance }
    end

    private

    ##
    # A hash that contains the created instances indexed by their multiton key.
    attr_accessor :hash

    ##
    # An instance of Sync[https://ruby-doc.org/stdlib-2.4.1/libdoc/sync/rdoc/Sync.html] to provide thread safety (via
    # a {shared-exclusive lock}[https://en.wikipedia.org/wiki/Readers%E2%80%93writer_lock]) when reading and writing
    # multiton instances to #hash.
    attr_accessor :sync
  end
end
