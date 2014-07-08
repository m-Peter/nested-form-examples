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
        name: "B-Wing",
        crew: 1,
        has_astromech: false,
        speed: 75,
        armament: "4 laser cannons, proton torpedoes",

        pilots_attributes: {
          "0" => {
            first_name: "Jon",
            last_name: "Vander",
            call_sign: "Gold Leader"
          }
        }
      }
    end

    ship_form = assigns(:ship_form)

    assert ship_form.valid?
    assert_redirected_to ship_path(ship_form)

    assert_equal "B-Wing", ship_form.name
    assert_equal 1, ship_form.crew
    assert_equal false, ship_form.has_astromech
    assert_equal 75, ship_form.speed
    assert_equal "4 laser cannons, proton torpedoes", ship_form.armament

    assert_equal "Jon", ship_form.pilots[0].first_name
    assert_equal "Vander", ship_form.pilots[0].last_name
    assert_equal "Gold Leader", ship_form.pilots[0].call_sign

    assert ship_form.pilots[0].persisted?

    assert_equal "The <b>B-Wing</b> ship has been created successfully.", flash[:notice]
  end

  test "should not create ship with invalid params" do
    assert_difference('Ship.count', 0) do
      post :create, ship: {
        name: nil,
        crew: 7,
        has_astromech: true,
        speed: 30,
        armament: nil,

        pilots_attributes: {
          "0" => {
            first_name: nil,
            last_name: nil,
            call_sign: "sign"
          }
        }
      }
    end

    ship_form = assigns(:ship_form)

    assert_not ship_form.valid?
    assert_includes ship_form.errors.messages[:name], "can't be blank"
    assert_includes ship_form.errors.messages[:crew], "must be between 1 and 5"
    assert_includes ship_form.errors.messages[:speed], "must be between 50 and 200"
    assert_includes ship_form.errors.messages[:first_name], "can't be blank"
    assert_includes ship_form.errors.messages[:last_name], "can't be blank"
    assert_includes ship_form.errors.messages[:call_sign], "is too short (minimum is 5 characters)"
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
    assert_difference('Ship.count', 0) do
      patch :update, id: @ship, ship: {
        name: "T-65 X-Wing",
        crew: 1,
        has_astromech: true,
        speed: 100,
        armament: "4 laser cannons, proton torpedoes",

        pilots_attributes: {
          "0" => {
            first_name: "Wedge",
            last_name: "Antilles",
            call_sign: "Red 2",
            id: @ship.pilots[0].id
          }
        }
      }
    end

    ship_form = assigns(:ship_form)
    
    assert ship_form.valid?
    assert_redirected_to ship_path(ship_form)

    assert_equal "T-65 X-Wing", ship_form.name
    assert_equal 1, ship_form.crew
    assert_equal true, ship_form.has_astromech
    assert_equal 100, ship_form.speed
    assert_equal "4 laser cannons, proton torpedoes", ship_form.armament

    assert_equal "Wedge", ship_form.pilots[0].first_name
    assert_equal "Antilles", ship_form.pilots[0].last_name
    assert_equal "Red 2", ship_form.pilots[0].call_sign

    assert ship_form.pilots[0].persisted?

    assert_equal "The <b>T-65 X-Wing</b> ship has been updated successfully.", flash[:notice]
  end

  test "should destroy ship" do
    assert_difference('Ship.count', -1) do
      delete :destroy, id: @ship
    end

    assert_redirected_to ships_path
  end
end
