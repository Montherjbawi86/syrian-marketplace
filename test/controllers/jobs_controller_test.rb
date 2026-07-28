require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jobs_index_url
    assert_response :success
  end

  test "should get show" do
    get jobs_show_url
    assert_response :success
  end

  test "should get listings" do
    get jobs_listings_url
    assert_response :success
  end

  test "should get seekers" do
    get jobs_seekers_url
    assert_response :success
  end

  test "should get seeker" do
    get jobs_seeker_url
    assert_response :success
  end
end
