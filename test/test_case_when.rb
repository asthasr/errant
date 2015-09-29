require_relative 'minitest_helper'

class TestCaseWhen < Minitest::Test
  def frobnicate(x)
    case x
    when Errant::Success
      true
    when Errant::Failure
      false
    end
  end

  def test_success
    assert frobnicate(Errant.capturing { 3 })
  end

  def test_failure
    refute frobnicate(Errant.capturing { fail "oops" })
  end
end
