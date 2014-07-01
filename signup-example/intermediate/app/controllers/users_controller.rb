class UsersController < ApplicationController
  def new
    @signup_form = SignupForm.new
  end

  def create
    @signup_form = SignupForm.new
    if @signup_form.submit(user_params)
      session[:user_id] = @signup_form.user.id
      redirect_to @signup_form.user, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end

  def show
    @user = current_user
  end

  private

  def user_params
    params.require(:user).permit(
      :username, :email, :password, :password_confirmation, :subscribed,
      :twitter_name, :github_name, :bio)
  end
end