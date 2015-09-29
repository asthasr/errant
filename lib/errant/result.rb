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
end
end
