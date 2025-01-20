require "test_helper"

class SignalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get signals_index_url
    assert_response :success
  end
end
