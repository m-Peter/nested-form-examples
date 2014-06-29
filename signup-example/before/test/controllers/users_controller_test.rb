require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get new" do
    get :new
    #assert_response :success
  end

  test "should create user" do
    #assert_difference('User.count') do
      #post :create, user: { email: @user.email, password: 'secret', password_confirmation: 'secret' }
    #end

    #assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    #get :show, id: @user
    #assert_response :success
  end
end
