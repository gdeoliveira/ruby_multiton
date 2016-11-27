module Multiton
  ##
  # TODO: Add documentation.
  module Mixin
    def _dump(_level)
      self.class.instance_variable_get(:@__multiton_instances).key(self)
    end

    def clone
      raise TypeError, "can't clone instance of multiton `#{self.class.name}`"
    end

    def dup
      raise TypeError, "can't dup instance of multiton `#{self.class.name}`"
    end
  end
end
