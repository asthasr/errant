require_relative 'minitest_helper'

class TestFlatten < Minitest::Test
  def nested_successes
    Errant::Success[Errant::Success[Errant::Success[42]]]
  end

  def nested_failures
    Errant::Failure[Errant::Failure["oops"]]
  end

  def mixed
    Errant::Success[Errant::Failure[Errant::Success[42]]]
  end

  def mixed_failures
    Errant::Failure[Errant::Failure[Errant::Success[42]]]
  end

  def test_successes_are_flattened
    assert_equal 42, nested_successes.flatten.value
  end

  def test_flatten_limit_is_respected
    result = nested_successes.flatten(1)
    assert_kind_of Errant::Success, result.value
    assert_equal 42, result.value.value
  end

  def test_nested_failures_are_flattened
    assert_equal "oops", nested_failures.flatten.value
  end

  def test_mixed_values_do_not_collapse_failure_into_success
    assert_kind_of Errant::Failure, mixed.flatten 
    assert_equal 42, mixed.flatten.value.value
  end

  def test_mixed_values_do_collapse_failures
    assert_kind_of Errant::Failure, mixed_failures.flatten
    assert_equal 42, mixed_failures.flatten.value.value
  end
end
