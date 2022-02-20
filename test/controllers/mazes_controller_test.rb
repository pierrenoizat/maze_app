require 'test_helper'

class MazesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mazes_index_url
    assert_response :success
  end

end
