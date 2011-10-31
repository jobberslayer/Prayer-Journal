require 'test_helper'

class PrayerRequestsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prayer_requests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prayer_request" do
    assert_difference('PrayerRequest.count') do
      post :create, :prayer_request => { }
    end

    assert_redirected_to prayer_request_path(assigns(:prayer_request))
  end

  test "should show prayer_request" do
    get :show, :id => prayer_requests(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => prayer_requests(:one).id
    assert_response :success
  end

  test "should update prayer_request" do
    put :update, :id => prayer_requests(:one).id, :prayer_request => { }
    assert_redirected_to prayer_request_path(assigns(:prayer_request))
  end

  test "should destroy prayer_request" do
    assert_difference('PrayerRequest.count', -1) do
      delete :destroy, :id => prayer_requests(:one).id
    end

    assert_redirected_to prayer_requests_path
  end
end
