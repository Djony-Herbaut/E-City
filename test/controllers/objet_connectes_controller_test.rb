require "test_helper"

class ObjetConnectesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get objet_connectes_index_url
    assert_response :success
  end
end
