module Errant
# This class is intended to be uncaught in most contexts. It is used to signal
# the "end" of a chain of implicit conversions to arrays for #flat_map and
# #flatten without losing information. In other contexts, calling #to_ary on a
# Result object is likely *not* what you should be doing.
class FailureSignal < Exception
  attr_reader :failure

  def initialize(failure)
    @failure = failure
  end
end
end
