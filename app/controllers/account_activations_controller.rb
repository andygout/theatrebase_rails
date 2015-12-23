class AccountActivationsController < ApplicationController
  before_action :get_user,  only: [:edit, :update]

  def edit
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
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
    params[:user][:updater_id] = current_user.id
    if password_blank?
      @user.errors.add(:password, 'Password cannot be blank')
      render :edit
    elsif @user.update_attributes(user_params)
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
    end

    def password_blank?
      params[:user][:password].blank?
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

end
