# Multiton

[![Gem Version](http://img.shields.io/gem/v/ruby_multiton.svg)][gem]
[![Build Status](http://img.shields.io/travis/gdeoliveira/ruby_multiton/master.svg)][travis]
[![Code Climate](http://img.shields.io/codeclimate/github/gdeoliveira/ruby_multiton.svg)][codeclimate]
[![Test Coverage](http://img.shields.io/codeclimate/coverage/github/gdeoliveira/ruby_multiton.svg)][codeclimate]
[![Inline docs](http://inch-ci.org/github/gdeoliveira/ruby_multiton.svg?branch=master)][inch-ci]

Multiton is an implementation of the [multiton pattern][multiton] in pure Ruby. Some its features include:

- Can be used to implement the [singleton pattern][singleton] in a very straightforwad way.
- Transparent interface that makes designing multiton classes as easy as designing regular ones.
- Support for [serializing][marshal_dump] and [deserializing][marshal_load] multiton instances.
- Clonning, duplicating and inheriting from a multiton class will create a *new* multiton class.
- Thread safety, implemented via [shared/exclusive locks][sync].
- [Compatible with MRI, JRuby and other Ruby implementations][travis].

## Installation

Add this line to your application's Gemfile:

```ruby
gem "ruby_multiton"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_multiton

## Usage

#### Implementing a singleton class

The easiest use case for Multiton is to implement a singleton class. To achieve this Multiton mimics the approach used
by the [Singleton module][singleton_module] from Ruby's standard library:

```ruby
require "multiton"

class C
  extend Multiton
end

C.instance.object_id  #=> 47143710911900
C.instance.object_id  #=> 47143710911900
```

As an example lets create a singleton object that returns the amount of seconds elapsed since it was first initialized:

```ruby
class Timestamp
  extend Multiton

  def initialize
    self.initialized_at = Time.now
  end

  def elapsed_seconds
    Time.now - initialized_at
  end

  private

  attr_accessor :initialized_at
end

Timestamp.instance  #=> #<Timestamp:0x00562e486384c8 @initialized_at=2017-04-17 20:00:15 +0000>

# Some time later...
Timestamp.instance.elapsed_seconds  #=> 542.955918039
```

#### Implementing a multiton class

To implement a multiton class we will need a `key` to be able to access the different instances afterwards. Multiton
achieves this by using the parameters passed to the `initialize` method as the `key`:

```ruby
require "multiton"

class C
  extend Multiton

  def initialize(key)
  end
end

C.instance(:one).object_id  #=> 47387777147320
C.instance(:one).object_id  #=> 47387777147320

C.instance(:two).object_id  #=> 47387776632880
C.instance(:two).object_id  #=> 47387776632880
```

As an example lets create multiton objects representing playing cards that we can check if they were drawn or not:

```ruby
class Card
  extend Multiton

  def initialize(number, suit)
    self.has_been_drawn = false
  end

  def draw
    self.has_been_drawn = true
  end

  def drawn?
    has_been_drawn
  end

  private

  attr_accessor :has_been_drawn
end

Card.instance(10, :spades).drawn?  #=> false

Card.instance(5, :hearts).draw
Card.instance(10, :spades).draw

Card.instance(5, :hearts).drawn?    #=> true
Card.instance(10, :spades).drawn?   #=> true
Card.instance(2, :diamonds).drawn?  #=> false
```

#### Serializing and deserializing multiton instances

Multiton instances can be serialized and deserialized like regular objects. Continuing with the previous `Card` example:

```ruby
Card.instance(2, :diamonds).drawn?  #=> false

serialized_card = Marshal.dump(Card.instance(2, :diamonds))

Marshal.load(serialized_card).drawn?  #=> false

Card.instance(2, :diamonds).draw

Marshal.load(serialized_card).drawn?  #=> true
```

#### Clonning, duplicating and inheriting from multiton classes

Multiton supports cloning, duplicating and inheriting from a multiton class:

```ruby
require "multiton"

class C
  extend Multiton
end

D = C.clone

E = D.dup

class F < E
end

F.instance.object_id  #=> 47418482076880
F.instance.object_id  #=> 47418482076880
```

Note that `C`, `D`, `E` and `F` are all considered different classes and will consequently not share any instances.

## Contributing

1. Fork it ( https://github.com/gdeoliveira/ruby_multiton/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[codeclimate]: https://codeclimate.com/github/gdeoliveira/ruby_multiton
[gem]: https://rubygems.org/gems/ruby_multiton
[inch-ci]: http://inch-ci.org/github/gdeoliveira/ruby_multiton
[marshal_dump]: https://ruby-doc.org/core-2.4.1/Marshal.html#method-c-dump
[marshal_load]: https://ruby-doc.org/core-2.4.1/Marshal.html#method-c-load
[multiton]: https://en.wikipedia.org/wiki/Multiton_pattern
[singleton]: https://en.wikipedia.org/wiki/Singleton_pattern
[singleton_module]: https://ruby-doc.org/stdlib-2.4.1/libdoc/singleton/rdoc/Singleton.html
[sync]: https://ruby-doc.org/stdlib-2.4.1/libdoc/sync/rdoc/Sync.html
[travis]: http://travis-ci.org/gdeoliveira/ruby_multiton/branches
