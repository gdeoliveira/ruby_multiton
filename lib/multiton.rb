require "extensible".freeze
require "multiton/instance_box".freeze
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
      @__multiton_instances = InstanceBox.new
    end
  end

  def _load(key)
    instance(*Marshal.load(key)) # rubocop:disable Security/MarshalLoad
  end

  def dup
    super.tap {|klass| klass.instance_variable_set(:@__multiton_instances, InstanceBox.new) }
  end

  def instance(*args)
    key = Marshal.dump(args)
    @__multiton_instances.get(key) || @__multiton_instances.register(key, new(*args))
  end

  private

  def allocate; end

  def inherited(subclass)
    super.tap { subclass.instance_variable_set(:@__multiton_instances, InstanceBox.new) }
  end

  def initialize_copy(_source)
    super.tap { extend Multiton }
  end

  def new(*args)
    super
  end
end
