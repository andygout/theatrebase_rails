class UsersController < ApplicationController

  include UsersHelper
  include Users::ViewsComponentsHelper
  include Shared::FormsHelper
  include Shared::GetUserHelper
  include Shared::ViewsComponentsHelper

  MODEL = 'User'

  before_action -> { get_user(params[:id]) },                         only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :logged_in_user
  before_action :not_suspended_user
  before_action -> { validate_user(super_or_admin?(current_user)) },  only: [:new, :create, :index]
  before_action -> { validate_user(current_user?(@user)) },           only: [:edit, :update]
  before_action -> { validate_user(valid_destroy_user?(@user)) },     only: :destroy
  before_action -> { validate_user(valid_show_user?(@user)) },        only: :show
  before_action -> { get_page_title(MODEL, get_user_page_title) },    only: [:new, :create, :edit, :update, :show]
  before_action -> { get_browser_tab(MODEL) },                        only: [:edit, :update, :show]
  before_action -> { get_content_header(MODEL) },                     only: [:new, :create, :edit, :update, :show]
  before_action :get_status_info,                                     only: [:new, :create, :edit, :update, :show]
  before_action -> { get_created_updated_info(@user) },               only: [:new, :create, :edit, :update]

  def new
  end

  def create
    @user = current_user.created_users.build(user_create_params)
    if @user.save
      @user.send_activation_email
      flash[:success] = 'ACCOUNT ACTIVATION INSTRUCTIONS SENT SUCCESSFULLY'
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_update_params)
      flash[:success] = success_msg(MODEL, 'updated', get_user_page_title)
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = success_msg(MODEL, 'deleted', get_user_page_title)
    if current_user == @user
      session.delete :user_id
      redirect_to root_path
    else
      redirect_to users_path
    end
  end

  def show
  end

  def index
    @page_title = "#{MODEL.pluralize.capitalize}"
    @users = get_users_for_index
    get_user_table @users
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

    def get_users_for_index
      current_user.super_admin ?
        User.non_admin(current_user, SuperAdmin).order(:id).paginate(page: params[:page]) :
        User.non_admin(current_user, SuperAdmin).non_admin(current_user, Admin).order(:id).paginate(page: params[:page])
    end

end
