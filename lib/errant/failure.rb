module Errant
class Failure < Result
  attr_reader :value

  def initialize(value)
    @value = value    
  end

  def method_missing(name, *args, &block)
    self
  end

  # Pass the wrapped error into the given block, returning an unwrapped value
  # from the block. This is useful for providing defaults.
  def or_else(&blk)
    yield value
  end

  # Perform side effects using the error. This is useful for logging and
  # debugging, although it should generally be avoided in production code, in
  # favor of error handling at a single location.
  def each_error(&blk)
    yield value
    self
  end

  # Pass the wrapped error into the given block and then rewrap the return
  # value in a new Failure. This is useful for normalization.
  def map_error(&blk)
    Failure.new(yield(value))
  end

  def successful?
    false
  end

  def self.[](value)
    Failure.new(value)
  end
end
end
