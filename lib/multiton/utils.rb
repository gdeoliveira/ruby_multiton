module Multiton
  ##
  # TODO: Add documentation.
  module Utils
    class << self
      if RUBY_VERSION >= "1.9".freeze
        def hash_key(hash, value)
          hash.key value
        end
      else
        # :nocov:
        def hash_key(hash, value)
          hash.index value
        end
        # :nocov:
      end
    end
  end
end
