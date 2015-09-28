require_relative "../errant"

module Errant
class Success
  attr_reader :exceptions, :value

  def initialize(*exceptions)
    @exceptions = exceptions
  end

  ([:each] + Enumerable.instance_methods).each do |enumerable_method|
    define_method(enumerable_method) do |*args, &block|
      begin
        res = __enumerable_value.send(enumerable_method, *args, &block)
        res.respond_to?(:each) ? __copy[res.first] : __copy[res]
      rescue *exceptions => e
        Failure[e]
      end
    end
  end

  def each_error(&blk)
    self
  end

  def map_error(&blk)
    self
  end

  def method_missing(name, *args, &block)
    __copy[@value.send(name, *args, &block)]
  rescue *exceptions => e
    Failure[e]
  end

  def or_else(&blk)
    value
  end

  def postprocess_error(&blk)
    Failure.new(yield(value))
  end

  def successful?
    true
  end

  def to_a
    __enumerable_value
  end

  def [](value)
    @value = value
    self
  end

  def self.[](value)
    new(*Result::DEFAULT_EXCEPTIONS)[value]
  end

  private

  def __copy
    Success.new(*exceptions)
  end

  def __enumerable_value
    [value]
  end
end
end
