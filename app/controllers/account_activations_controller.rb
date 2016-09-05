class AccountActivationsController < ApplicationController

  include Shared::ViewsComponentsHelper

  before_action :get_user
  before_action :get_page_title

  def edit
    if @user && !@user.activated_at? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash.now[:success] = 'Account activated'
      render :edit
    else
      flash[:error] = 'Invalid activation link'
      redirect_to root_path
    end
  end

  def update
    if password_blank?
      @user.errors.add(:password, 'Password cannot be blank')
      render :edit
    elsif @user.update(user_params)
      flash[:success] = 'Password has been set'
      redirect_to @user
    else
      render :edit
    end
  end

  private

    def user_params
      params
        .require(:user)
        .permit(:password,
                :password_confirmation)
        .merge(updater_id: current_user.id)
    end

    def get_user
      @user = User.find_by_email(params[:email])
    end

    def get_page_title
      @page_title = "Set password: #{get_user_page_title}" if @user
    end

    def password_blank?
      params[:user][:password].blank?
    end

end
