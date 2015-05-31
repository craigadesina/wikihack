class UsersController < ApplicationController
  
  before_action :authenticate_user!

  def index
    @users = User.all
    authorize @users
  end

  def show
    @user = User.find(params[:id])
    @wikis = @user.wikis.all
    authorize @user
    #@wiki = current_user
  end

  def update
    authorize current_user
    if current_user.update_attribute(user_params)
      flash[:notice] = "User role updated"
      redirect_to edit_user_registration_path
    else
      flash[:error] = "Invalid user role"
      redirect_to edit_user_registration_path
    end
  end

  def destroy
      @user = User.find(params[:id])
      authorize @user
      if @user.destroy
      flash[:notice] = "user was sucessfully deleted"
      redirect_to current_user
    else
      flash[:error] = "Sorry, user could not be deleted"
      redirect_to current_user
    end
  end


  private

  def user_params
    params.require(:user).permit(:role)
  end
end