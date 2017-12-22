require 'test_helper'

class FetchControllerTest < ActionDispatch::IntegrationTest
  test "should get shopify" do
    get fetch_shopify_url
    assert_response :success
  end

end
