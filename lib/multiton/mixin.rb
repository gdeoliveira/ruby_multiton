module Multiton
  ##
  # Mixin adds appropriate behavior to multiton instances.
  module Mixin
    ##
    # call-seq:
    #   _dump(_level) => string
    #
    # Serializes the instance as a string that can be reconstituted at a later point. The parameter +_level+ is not
    # used, but it is needed for marshalling to work correctly.
    #
    # Returns a string representing the serialized multiton instance.
    def _dump(_level)
      self.class.instance_variable_get(:@__multiton_instances).key self
    end

    ##
    # call-seq:
    #   clone
    #
    # Raises a TypeError[https://ruby-doc.org/core-2.4.1/TypeError.html] since multiton instances can not be cloned.
    #
    # Never returns.
    def clone
      raise TypeError, "can't clone instance of multiton `#{self.class.name}`"
    end

    ##
    # call-seq:
    #   dup
    #
    # Raises a TypeError[https://ruby-doc.org/core-2.4.1/TypeError.html] since multiton instances can not be duplicated.
    #
    # Never returns.
    def dup
      raise TypeError, "can't dup instance of multiton `#{self.class.name}`"
    end
  end
end
