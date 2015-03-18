# TODO this test is now duplicated as a controller spec. OK to remove
# TODO once removed, rest of /test folder can be removed as well

require 'test_helper'

class TripsControllerTest < ActionController::TestCase
  setup do
    @trip = trips(:one)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:trips)
  end

  test "should get new" do
    get :new, :customer_id=>1
    assert_response :success
  end

  test "should create trip" do
    assert_difference('Trip.count') do
      post :create, :trip => @trip.dup.attributes.compact
    end

    assert_redirected_to trips_path(:start => @trip.pickup_time.to_i)
  end

  # The action method is not defined in TripsController
  # test "should show trip" do
  #   get :show, :id => @trip.to_param
  #   assert_response :success
  # end

  test "should get edit" do
    get :edit, :id => @trip.to_param
    assert_response :success
  end

  test "should update trip" do
    put :update, :id => @trip.to_param, :trip => @trip.attributes
    assert_redirected_to trips_path
  end

  test "should destroy trip" do
    assert_difference('Trip.count', -1) do
      delete :destroy, :id => @trip.to_param
    end

    assert_redirected_to trips_path
  end
end
