module Multiton
  ##
  # TODO: Add documentation.
  module Mixin
    def clone
      raise TypeError, "can't clone instance of multiton `#{self.class.name}`"
    end

    def dup
      raise TypeError, "can't dup instance of multiton `#{self.class.name}`"
    end

    private

    def _dump(_level)
      self.class.multiton_key self
    end
  end
end
