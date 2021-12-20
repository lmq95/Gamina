require 'test_helper'

class HogesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get hoges_top_url
    assert_response :success
  end

end
