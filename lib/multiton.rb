require "extensible".freeze
require "multiton/instance_box".freeze
require "multiton/mixin".freeze
require "multiton/version".freeze

##
# The Multiton extension implements the {multiton pattern}[https://en.wikipedia.org/wiki/Multiton_pattern] in a manner
# similar to Ruby standard library's Singleton[https://ruby-doc.org/stdlib-2.4.1/libdoc/singleton/rdoc/Singleton.html]
# module. As a matter of fact Multiton can be used to implement the singleton pattern in a very straightforward way:
#
#   class C
#     extend Multiton
#   end
#
#   C.instance.object_id  #=> 47362978769640
#   C.instance.object_id  #=> 47362978769640
#
# In order to generate and access different instances a +key+ must be provided as a parameter to the +initialize+
# method:
#
#   class C
#     extend Multiton
#
#     def initialize(key)
#       # Initialize this instance (if needed).
#     end
#   end
#
#   one = C.instance(:one)
#   two = C.instance(:two)
#
#   one.object_id               #=> 46941338337020
#   C.instance(:one).object_id  #=> 46941338337020
#
#   two.object_id               #=> 46941338047140
#   C.instance(:two).object_id  #=> 46941338047140
#
# Almost any object or set of objects will work as a valid +key+. The +key+ assembly is transparently handled by
# Multiton internally, leaving the end user with an uncluttered and familiar way of designing their classes:
#
#   class Person
#     extend Multiton
#
#     attr_reader :full_name
#
#     def initialize(name:, surname:)
#       self.full_name = "#{surname}, #{name} --- (id: #{object_id})".freeze
#     end
#
#     private
#
#     attr_writer :full_name
#   end
#
#   alice = Person.instance(name: "Alice", surname: "Alcorta")
#   bob = Person.instance(name: "Bob", surname: "Berman")
#
#   alice.full_name                                               #=> "Alcorta, Alice --- (id: 46921440327980)"
#   Person.instance(name: "Alice", surname: "Alcorta").full_name  #=> "Alcorta, Alice --- (id: 46921440327980)"
#
#   bob.full_name                                                 #=> "Berman, Bob --- (id: 46921440022260)"
#   Person.instance(name: "Bob", surname: "Berman").full_name     #=> "Berman, Bob --- (id: 46921440022260)"
#
# Note that even though keyword arguments will work with Multiton, passing the keywords in a different order will
# generate a different instance. It is left up to the end user to design their +key+ in a way that minimizes the
# possibility of improper use.
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

  ##
  # call-seq:
  #   _load(args_string) => an_instance
  #
  # Creates or reconstitutes a multiton instance from +args_string+, which is a marshalled representation of the +key+
  # argument(s) passed to #instance.
  #
  # Returns a multiton instance.
  def _load(args_string)
    instance(*Marshal.load(args_string)) # rubocop:disable Security/MarshalLoad
  end

  ##
  # call-seq:
  #   dup => a_class
  #
  # Creates a duplicate of the multiton class. Instances will not be shared between the original and duplicate classes.
  #
  # Returns a new class.
  def dup
    super.tap {|klass| klass.instance_variable_set(:@__multiton_instances, InstanceBox.new) }
  end

  ##
  # call-seq:
  #   instance(*args_key) => an_instance
  #
  # Creates or retrieves the instance corresponding to +args_key+.
  #
  # Returns a multiton instance.
  def instance(*args_key)
    key = Marshal.dump(args_key)
    @__multiton_instances.get(key) || @__multiton_instances.store(key, new(*args_key))
  end

  private

  ##
  # call-seq:
  #   allocate => nil
  #
  # Empty implementation of the +allocate+ method to block the original implemented in +Class+. Effectively does
  # nothing.
  #
  # Returns +nil+.
  def allocate; end

  ##
  # call-seq:
  #   inherited(subclass) => nil
  #
  # This is called when a multiton class is inherited to properly initialize +subclass+. Instances will not be shared
  # between the superclass and its subclasses.
  #
  # Returns +nil+.
  def inherited(subclass)
    super
    subclass.instance_variable_set(:@__multiton_instances, InstanceBox.new)
    nil
  end

  ##
  # call-seq:
  #   initialize_copy(_source) => self
  #
  # This is called (on the clone) when a multiton class (+_source+) is cloned to properly initialize it. Instances will
  # not be shared between the original and cloned classes.
  #
  # Returns +self+.
  def initialize_copy(_source)
    super
    extend Multiton
    self
  end

  ##
  # call-seq:
  #   new(*args) => new_instance
  #
  # Creates a new multiton instance and initializes it by passing +args+ to its constructor.
  #
  # Returns a new multiton instance.
  def new(*args)
    super
  end
end
