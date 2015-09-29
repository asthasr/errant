require_relative 'minitest_helper'

class TestChaining < Minitest::Test
  def setup
    @expected_message = "an error occurred"
  end

  def simple_chain
    Errant.capturing { 3 }
      .map { |n| n * 2 }
      .map { |n| n.to_s }
  end

  def test_successful_chain_and_unwrap
    result = simple_chain.or_else { @expected_message }
    assert_equal "6", result
  end

  def test_failing_chain_and_unwrap
    result = simple_chain
      .map { |_| fail @expected_message }
      .or_else { |e| e.message }
    assert_equal @expected_message, result
  end

  def test_successful_map_error
    result = simple_chain.map_error { |e| "this shouldn't happen" }
    assert_equal simple_chain.value, result.value
    assert result.is_a? Errant::Success
  end

  def test_failing_map_error
    result = simple_chain
      .map { |_| fail @expected_message }
      .map_error { |e| e.message }
    assert_equal @expected_message, result.value
    assert result.is_a? Errant::Failure
  end
end
