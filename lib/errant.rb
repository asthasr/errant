require_relative "errant/version"
require_relative "errant/result"

module Errant
  module_function

  def capturing(*exceptions, &blk)
    Result.new(*exceptions).call(&blk)
  end
end
