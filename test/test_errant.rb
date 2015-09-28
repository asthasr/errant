require_relative 'minitest_helper'

require 'minitest/autorun'

class TestException < Exception ; end

class TestErrant < Minitest::Test
  def test_default_capturing
    assert_equal(
      Errant::Result::DEFAULT_EXCEPTIONS,
      Errant::Result.new.exceptions
    )
  end

  def test_simple_block_succeeds
    result = Errant.capturing { 3 }
    assert result.is_a?(Errant::Success)
    assert_equal 3, result.value
  end

  def test_error_is_captured
    result = Errant.capturing(TestException) do
      fail TestException, "Mediocre!"
    end

    assert result.is_a?(Errant::Failure)
    assert result.value.is_a?(TestException)
  end

  def test_uncaptured_error_is_not_captured
    assert_raises RuntimeError do
      Errant.capturing(TestException) { fail "Mediocre!" }
    end
  end
end
