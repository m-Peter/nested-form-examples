class UsersController < ApplicationController
  def new
    @user = User.new
    @signup_form = SignupForm.new(@user)
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new
    @signup_form = SignupForm.new(@user)

    @signup_form.submit(user_params)

    if @signup_form.save
      session[:user_id] = @signup_form.model.id
    else
      render "new"
    end
  end

  private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :username, :email, :password, :password_confirmation, :subscribed,
        profile_attributes: [:twitter_name, :github_name, :bio]
      )
    end
end
