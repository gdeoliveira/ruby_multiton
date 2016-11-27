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

    klass.class_eval do
      include Mixin
      @__multiton_instances = {}
    end
  end

  def dup
    super.tap {|klass| klass.instance_variable_set(:@__multiton_instances, {}) }
  end

  def instance(*args)
    @__multiton_instances[Marshal.dump(args)] ||= new(*args)
  end

  private

  def _load(key)
    instance(*Marshal.load(key))
  end

  def allocate
  end

  def inherited(subclass)
    super.tap { subclass.instance_variable_set(:@__multiton_instances, {}) }
  end

  def initialize_copy(_source)
    super.tap { @__multiton_instances = {} }
  end

  def new(*args)
    super
  end
end
