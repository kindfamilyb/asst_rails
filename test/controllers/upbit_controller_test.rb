require "test_helper"

class UpbitControllerTest < ActionDispatch::IntegrationTest
  test "should get main" do
    get upbit_main_url
    assert_response :success
  end
end
