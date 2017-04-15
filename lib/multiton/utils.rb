module Multiton
  ##
  # Adds compatibility methods to support different Ruby versions.
  module Utils
    class << self
      if RUBY_VERSION >= "1.9".freeze
        ##
        # call-seq:
        #   hash_key(hash, value) => key
        #
        # Returns the key associated with +value+ on +hash+. If +value+ does not exist returns +nil+.
        def hash_key(hash, value)
          hash.key value
        end
      else
        # :nocov:

        ##
        # call-seq:
        #   hash_key(hash, value) => key
        #
        # Returns the key associated with +value+ on +hash+. If +value+ does not exist returns +nil+.
        def hash_key(hash, value)
          hash.index value
        end
        # :nocov:
      end
    end
  end
end
