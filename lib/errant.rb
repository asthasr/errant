require_relative "errant/version"
require_relative "errant/result"
require_relative "errant/success"
require_relative "errant/failure"

module Errant
  module_function

  def capturing(*exceptions, &blk)
    Success.new(*exceptions).map { |_| yield(blk) }
  end
end
