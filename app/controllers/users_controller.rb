class UsersController < ApplicationController

  include UsersHelper
  include Users::ViewsComponentsHelper
  include Shared::ViewsComponentsHelper
  include Shared::FormsHelper

  before_action :get_user,              only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :logged_in_user
  before_action :not_suspended_user
  before_action :admin_user,            only: [:new, :create, :index]
  before_action :correct_user,          only: [:edit, :update]
  before_action :destroy_user,          only: :destroy
  before_action :show_user,             only: :show
  before_action :get_views_components,  only: [:new, :create, :edit, :update, :show]
  before_action :get_form_components,   only: [:new, :create, :edit, :update]

  def new
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
    get_user_page_title @user
  end

  def update
    if @user.update(user_update_params)
      flash[:success] = 'User updated successfully'
      redirect_to @user
    else
      get_user_page_title User.find(params[:id])
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
    get_user_page_title @user
  end

  def index
    @users = current_user.super_admin ?
      User.non_admin(current_user, SuperAdmin).order(:id).paginate(page: params[:page]) :
      User.non_admin(current_user, SuperAdmin).non_admin(current_user, Admin).order(:id).paginate(page: params[:page])
    get_user_index_table
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
      @user = params[:id] ? User.find(params[:id]) : User.new
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

    def get_views_components
      get_content_header 'user'
      get_status_info
    end

    def get_form_components
      get_created_updated_info @user
    end

end
