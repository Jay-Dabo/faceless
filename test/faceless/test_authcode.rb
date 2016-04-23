require 'test_helper'

class Authcode < Minitest::Test
  def setup
    Faceless.configure do |config|
      config.auth_token = 'test-token'
    end

    @authenticator = Faceless::Authcode
  end

  def test_encode
    assert @authenticator.encode("encrypt-me").length > 0
  end

  def test_decode
    assert_equal "encrypt-me",
      @authenticator.decode("2d4enq1n92Am7AX7+z9yuqAItMzrgeuBCqA3/R1YX7GJk4/lZE8g")
  end
end