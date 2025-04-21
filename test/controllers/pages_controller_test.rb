require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get e_city_histoire" do
    get pages_e_city_histoire_url
    assert_response :success
  end
end
