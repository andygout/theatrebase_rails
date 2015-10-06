class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "User created successfully: #{@user.name} (#{@user.email})"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @page_title = @user.name
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated successfully: #{@user.name}"
      redirect_to @user
    else
      @page_title = User.find(params[:id]).name
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted successfully: #{@user.name}"
    redirect_to users_path
  end

  private

    def user_params
      params.require(:user).permit( :name,
                                    :email,
                                    :password,
                                    :password_confirmation
                                  )
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:error] = 'Please log in'
        redirect_to login_path
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user? @user
    end

end
