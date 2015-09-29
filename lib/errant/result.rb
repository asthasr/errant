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

  # This is the most complex logic for dealing with Errant objects. It is
  # intended to flatten a series of Result objects into a single, logical
  # Result:
  #
  #   Success[Success[Success[3]]].flatten => Success[3]
  #   Success[Success[Success[3]]].flatten(1) => Success[Success[3]]
  #   Failure[Failure[e]].flatten => Failure[e]
  #
  # However, there is one more complex rule: we never want to collapse a
  # Failure into a Success.
  #
  #   Success[Failure[e]].flatten => Failure[e]
  #   Success[Failure[Success[3]]].flatten = Failure[Success[3]]
  #
  # Recursion would make this relatively easy, but is risky on MRI.
  def flatten(limit = nil)
    return self unless value.is_a?(Result)
    return self if self.is_a?(Failure) && value.is_a?(Success)

    limit = 0 if !limit.nil? && limit < 0

    current_value = value

    while current_value.is_a?(Result) && (limit.nil? || limit > 0) do
      previous_value = current_value
      current_value = previous_value.value
      limit -= 1 unless limit.nil?
      break if current_value.is_a?(Success) && previous_value.is_a?(Failure)
    end

    previous_value.nil? ? current_value : previous_value
  end
end
end
