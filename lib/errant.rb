require_relative "errant/version"
require_relative "errant/result"
require_relative "errant/success"
require_relative "errant/failure"
require_relative "errant/failure_signal"

module Errant
  module_function

  def capturing(*exceptions, &blk)
    Success.new(*exceptions).map { |_| yield(blk) }
  end
end
