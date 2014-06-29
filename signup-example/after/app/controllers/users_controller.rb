class UsersController < ApplicationController
  def new
    @user = User.new
    @signup_form = SignupForm.new(@user)
  end

  def show
  end

  def create
    @user = User.new
    @signup_form = SignupForm.new(@user)

    @signup_form.submit(user_params)

    if @signup_form.save
      session[:user_id] = @signup_form.user.id
    else
      render "new"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :username, :email, :password, :password_confirmation, :subscribed,
        profile_attributes: [:twitter_name, :github_name, :bio]
      )
    end
end
