require "test_helper"

class HangukControllerTest < ActionDispatch::IntegrationTest
  test "should get account" do
    get hanguk_account_url
    assert_response :success
  end
end
