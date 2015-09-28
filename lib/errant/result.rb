require_relative "success"
require_relative "failure"

module Errant
class Result
  attr_reader :exceptions

  DEFAULT_EXCEPTIONS = [StandardError]

  def initialize(*exceptions, &blk)
    if exceptions.length == 0
      @exceptions = DEFAULT_EXCEPTIONS
    else
      @exceptions = exceptions
    end
  end
  
  def call(&blk)
    value = yield(blk)
    Success.new(*exceptions)[value]
  rescue *exceptions => e
    Failure[e]
  end
end
end
