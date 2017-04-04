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
