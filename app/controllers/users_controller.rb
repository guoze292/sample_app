class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
  	@user = User.find(params[:id])

  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "welcome to the sample app!"
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end




  private
  #rails 不允许用户直接在params上操作，通过这个方法限定params以防出现问题。
    def user_params
      params.require(:user).permit(:name, :email, :password,
                               :password_confirmation)
    end

end
