class AccountActivationsController < ApplicationController

  before_action :get_user

  def edit
    if @user && !@user.activated_at? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      @page_title = "#{@user.name} (#{@user.email})"
      flash.now[:success] = 'Account activated'
      render :edit
    else
      flash[:error] = 'Invalid activation link'
      redirect_to root_path
    end
  end

  def update
    @page_title = "#{@user.name} (#{@user.email})"
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
                :password_confirmation,
                :updater_id)
        .merge(updater_id: current_user.id)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def password_blank?
      params[:user][:password].blank?
    end

end
