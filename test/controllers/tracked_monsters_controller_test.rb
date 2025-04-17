require "test_helper"

class TrackedMonstersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tracked_monsters_index_url
    assert_response :success
  end

  test "should get create" do
    get tracked_monsters_create_url
    assert_response :success
  end

  test "should get destroy" do
    get tracked_monsters_destroy_url
    assert_response :success
  end

  test "should get reset_timer" do
    get tracked_monsters_reset_timer_url
    assert_response :success
  end
end
