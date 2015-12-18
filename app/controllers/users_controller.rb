class UsersController < ApplicationController

  before_action :logged_in_user,  only: [:index, :edit, :update, :show, :destroy]
  before_action :admin_user,      only: [:index, :new, :create]
  before_action :correct_user,    only: [:edit, :update]
  before_action :show_user,       only: :show
  before_action :destroy_user,    only: :destroy

  def index
    @users = User.where(activated: true).order(:id).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @password = SecureRandom.urlsafe_base64
    params[:user][:password] = @password
    params[:user][:password_confirmation] = @password
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = "Account activation details for #{@user.name} sent to: #{@user.email}"
      redirect_to root_path
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
    redirect_to root_path and return unless @user.activated?
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted successfully: #{@user.name}"
    if current_user == @user
      session.delete :user_id
      redirect_to root_path
    else
      redirect_to users_path
    end
  end

  private

    def user_params
      params.require(:user).permit( :name,
                                    :email,
                                    :password,
                                    :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:error] = 'Please log in'
        redirect_to login_path
      end
    end

    def admin_user
      validate_user admin? current_user
    end

    def correct_user
      validate_user current_user? find_user(params[:id])
    end

    def show_user
      validate_user valid_show_user? find_user(params[:id])
    end

    def destroy_user
      validate_user valid_destroy_user? find_user(params[:id])
    end

    def find_user user_id
      @user = User.find(user_id)
    end

    def validate_user user_valid
      unless user_valid
        flash[:error] = 'Access denied'
        redirect_to root_path
      end
    end

end
