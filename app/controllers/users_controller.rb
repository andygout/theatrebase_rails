class UsersController < ApplicationController

  include UsersHelper

  before_action :get_user,          only: [:edit, :update, :destroy, :show]
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
    @user = current_user.created_users.build_with_user(user_create_params, current_user)
    if @user.save
      @user.send_activation_email
      flash[:success] = "Account activation details for #{@user.name} sent to: #{@user.email}"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @page_title = "#{@user.name} (#{@user.email})"
  end

  def update
    if @user.update(user_update_params)
      @user.update_attribute(:updater_id, current_user.id)
      flash[:success] = "User updated successfully: #{@user.name}"
      redirect_to @user
    else
      @user_name_email = User.find(params[:id])
      @page_title = "#{@user_name_email.name} (#{@user_name_email.email})"
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
    @page_title = "#{@user.name} (#{@user.email})"
    redirect_to root_path and return unless @user.activated?
  end

  def index
    @users = User.where(activated: true).order(:id).paginate(page: params[:page])
  end

  private

    def user_create_params
      params
        .require(:user)
        .permit(:name,
                :email)
    end

    def user_update_params
      params
        .require(:user)
        .permit(:name,
                :email,
                :password,
                :password_confirmation)
    end

    def get_user
      @user = User.find(params[:id])
    end

    def admin_user
      validate_user super_or_admin? current_user
    end

    def correct_user
      validate_user current_user? @user
    end

    def destroy_user
      validate_user valid_destroy_user? @user
    end

    def show_user
      validate_user valid_show_user? @user
    end

end
