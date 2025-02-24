require "test_helper"

class PackagemarketControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get packagemarket_index_url
    assert_response :success
  end
end
