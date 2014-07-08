require 'test_helper'

class ShipsControllerTest < ActionController::TestCase
  setup do
    @ship = ships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ship" do
    assert_difference('Ship.count') do
      post :create, ship: {
        armament: "4 laser cannons, proton torpedoes",
        crew: 1,
        has_astromech: true,
        name: "T-65 X-Wing",
        speed: 100
      }
    end

    assert_redirected_to ships_path
  end

  test "should show ship" do
    get :show, id: @ship
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ship
    assert_response :success
  end

  test "should update ship" do
    patch :update, id: @ship, ship: { armament: @ship.armament, crew: @ship.crew, has_astromech: @ship.has_astromech, name: @ship.name, speed: @ship.speed }
    assert_redirected_to ships_path
  end

  test "should destroy ship" do
    assert_difference('Ship.count', -1) do
      delete :destroy, id: @ship
    end

    assert_redirected_to ships_path
  end
end
