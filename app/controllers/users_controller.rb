class UsersController < ApplicationController

  include UsersHelper
  include FormsHelper

  before_action :get_user,          only: [:edit, :update, :destroy, :show]
  before_action :logged_in_user
  before_action :not_suspended_user
  before_action :admin_user,        only: [:new, :create, :index]
  before_action :correct_user,      only: [:edit, :update]
  before_action :destroy_user,      only: :destroy
  before_action :show_user,         only: :show
  before_action :get_page_header,   only: [:new, :edit, :show]

  def new
    @user = User.new
    get_created_updated_table
  end

  def create
    @user = current_user.created_users.build_with_user(user_create_params, current_user)
    if @user.save
      @user.send_activation_email
      flash[:success] = 'Account activation instructions sent successfully'
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @page_title = "#{@user.name} (#{@user.email})"
    get_created_updated_table
  end

  def update
    if @user.update(user_update_params)
      flash[:success] = 'User updated successfully'
      redirect_to @user
    else
      @user_name_email = User.find(params[:id])
      @page_title = "#{@user_name_email.name} (#{@user_name_email.email})"
      get_created_updated_table
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted successfully"
    if current_user == @user
      session.delete :user_id
      redirect_to root_path
    else
      redirect_to users_path
    end
  end

  def show
    @page_title = "#{@user.name} (#{@user.email})"
  end

  def index
    @users = User.order(:id).paginate(page: params[:page])
  end

  private

    def user_create_params
      @password = SecureRandom.urlsafe_base64
      params
        .require(:user)
        .permit(:name,
                :email)
        .merge( password: @password,
                password_confirmation: @password,
                updater_id: current_user.id)
    end

    def user_update_params
      params
        .require(:user)
        .permit(:name,
                :email,
                :password,
                :password_confirmation)
        .merge(updater_id: current_user.id)
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

    def get_created_updated_table
      @created_updated_info = create_created_updated_markup(@user).html_safe
    end

    def get_page_header
      @content_header = "<p class='content-label content-header'>USER</p>".html_safe
    end

end
