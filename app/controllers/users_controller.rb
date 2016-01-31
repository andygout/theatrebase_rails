class UsersController < ApplicationController

  before_action :logged_in_user
  before_action :not_suspended_user
  before_action :admin_user,        only: [:new, :create, :index]
  before_action :correct_user,      only: [:edit, :update]
  before_action :destroy_user,      only: :destroy
  before_action :show_user,         only: :show

  def new
    @user = User.new
  end

  def create
    @password = SecureRandom.urlsafe_base64
    params[:user][:password] = @password
    params[:user][:password_confirmation] = @password
    params[:user][:updater_id] = current_user.id
    @user = current_user.created_users.build_with_user(user_params, current_user)
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
    params[:user][:updater_id] = current_user.id
    if @user.update(user_params)
      flash[:success] = "User updated successfully: #{@user.name}"
      redirect_to @user
    else
      @page_title = User.find(params[:id]).name
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted successfully: #{@user.name}"
    if current_user == @user
      session.delete :user_id
      redirect_to root_path
    else
      redirect_to users_path
    end
  end

  def show
    redirect_to root_path and return unless @user.activated?
  end

  def index
    @users = User.where(activated: true).order(:id).paginate(page: params[:page])
  end

  private

    def user_params
      params
        .require(:user)
        .permit(:name,
                :email,
                :password,
                :password_confirmation,
                :updater_id)
    end

    def get_user
      @user = User.find(params[:id])
    end

    def not_suspended_user
      validate_user not_suspended_user?
    end

    def admin_user
      validate_user super_or_admin? current_user
    end

    def correct_user
      validate_user current_user? get_user(params[:id])
    end

    def destroy_user
      validate_user valid_destroy_user? get_user(params[:id])
    end

    def show_user
      validate_user valid_show_user? get_user(params[:id])
    end

    def get_user user_id
      @user = User.find(user_id)
    end

    def validate_user user_valid
      unless user_valid
        flash[:error] = 'Access denied'
        redirect_to root_path
      end
    end

end
