module Multiton
  ##
  # TODO: Add documentation.
  module Utils
    class << self
      if RUBY_VERSION >= "1.9".freeze
        def hash_key(hash, key)
          hash.key key
        end
      else
        def hash_key(hash, key)
          hash.index key
        end
      end
    end
  end
end
