require_relative 'minitest_helper'

class TestFlatMap < Minitest::Test
  def successful_fn(n)
    Errant.capturing { n * 2 }
  end

  def failure_fn(n)
    Errant.capturing { fail "oops (#{n})" }
  end

  def test_successful_chain_returns_one_result
    result = successful_fn(2)
      .flat_map { |n| successful_fn(n) }
      .flat_map { |n| successful_fn(n) }
      .flat_map { |n| successful_fn(n) }

    assert_kind_of Errant::Result, result
    assert_equal 32, result.value
  end

  def test_failing_chain_returns_one_result
    result = successful_fn(2)
      .flat_map { |n| successful_fn(n) }
      .flat_map { |n| failure_fn(n) }
      .flat_map { |n| successful_fn(n) }

    assert_kind_of Errant::Result, result
    assert_kind_of StandardError, result.value
    assert_equal "oops (8)", result.value.message
  end
end
