require "extensible".freeze
require "multiton/mixin".freeze
require "multiton/version".freeze

##
# TODO: Add documentation.
module Multiton
  extend Extensible

  when_extended do |klass|
    unless klass.is_a? Class
      raise TypeError, "expected to extend object of type `Class` with module `#{name}`, got `#{klass.class}` instead"
    end

    klass.include Mixin
    klass.instance_variable_set(:@multiton_instances, {})
  end

  def dup
    super.tap do |klass|
      klass.instance_variable_set(:@multiton_instances, {})
    end
  end

  def instance(*args)
    # TODO: Should the key be frozen for earlier versions of Ruby?
    multiton_instances[Marshal.dump(args)] ||= new(*args)
  end

  # TODO: Should this be private?
  def multiton_key(instance)
    multiton_instances.key(instance)
  end

  private

  attr_accessor :multiton_instances

  def _load(key)
    instance(*Marshal.load(key))
  end

  def allocate
    super
  end

  def initialize_copy(_source)
    super
    self.multiton_instances = {}
  end

  def new(*args)
    super
  end
end
