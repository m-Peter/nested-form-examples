require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should login" do
    peter = users(:peter)
    post :create, email: peter.email, password: 'secret'
    
    assert_redirected_to root_url
    assert_equal peter.id, session[:user_id]
    assert_equal "Logged in!", flash[:notice]
  end

  test "should fail login" do
    peter = users(:peter)
    post :create, email: peter.email, password: 'wrong'
    
    assert_nil session[:user_id]
    assert_equal "Email or password is invalid", flash[:alert]
  end

  test "should logout" do
    delete :delete
    
    assert_redirected_to root_url
    assert_equal "Logged out!", flash[:notice]
  end
end
