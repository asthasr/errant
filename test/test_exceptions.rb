require_relative 'minitest_helper'

class TestException < Exception ; end

class TestFailureExceptions < Minitest::Test
  def test_defaults_are_available_on_success
    assert_equal(
      Errant::Success[3].exceptions,
      Errant::Result::DEFAULT_EXCEPTIONS
    )
  end

  def test_defaults_are_available_on_failure
    assert_equal(
      Errant::Failure[3].exceptions,
      Errant::Result::DEFAULT_EXCEPTIONS
    )
  end

  def test_captured_exceptions_are_transferred
    failure = Errant.capturing(TestException) { 3 }
      .map { fail TestException, "oops" }

    assert_equal(
      failure.exceptions,
      [TestException]
    )
  end
end
