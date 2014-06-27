require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:peter)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference(['User.count', 'Email.count', 'Profile.count']) do
      post :create, user: {
        age: "23",
        gender: "0",
        name: "petrakos",

        email_attributes: {
          address: "petrakos@gmail.com"  
        },

        profile_attributes: {
          twitter_name: "t_peter",
          github_name: "g_peter"
        }
      }
    end

    user_form = assigns(:user_form)

    assert_redirected_to user_path(user_form)
    assert_equal "petrakos", user_form.name
    assert_equal 23, user_form.age
    assert_equal 0, user_form.gender
    assert_equal "petrakos@gmail.com", user_form.email.address
    assert_equal "t_peter", user_form.profile.twitter_name
    assert_equal "g_peter", user_form.profile.github_name
    assert_equal "User: #{user_form.name} was successfully created.", flash[:notice]
  end

  test "should not create user with invalid params" do
    peter = users(:peter)

    assert_difference(['User.count', 'Email.count', 'Profile.count'], 0) do
      post :create, user: {
        name: peter.name,
        age: "23",
        gender: "0",

        email_attributes: {
          address: peter.email.address
        },

        profile_attributes: {
          twitter_name: peter.profile.twitter_name,
          github_name: peter.profile.github_name
        }
      }
    end

    user_form = assigns(:user_form)

    assert_includes user_form.errors.messages[:name], "has already been taken"
    assert_includes user_form.errors.messages[:address], "has already been taken"
    assert_includes user_form.errors.messages[:twitter_name], "has already been taken"
    assert_includes user_form.errors.messages[:github_name], "has already been taken"
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: {
      name: "petrakos",
      age: @user.age,
      gender: @user.gender,

      email_attributes: {
        address: "petrakos@gmail.com"
      },

      profile_attributes: {
        twitter_name: "t_peter",
        github_name: "g_peter"
      }
    }

    user_form = assigns(:user_form)

    assert_redirected_to user_path(user_form)
    assert_equal "petrakos", user_form.name
    assert_equal "petrakos@gmail.com", user_form.email.address
    assert_equal "t_peter", user_form.profile.twitter_name
    assert_equal "g_peter", user_form.profile.github_name
    assert_equal "User: #{user_form.name} was successfully updated.", flash[:notice]
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
