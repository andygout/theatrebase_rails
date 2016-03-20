class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      clearance_check user
    else
      flash.now[:error] = 'Invalid email-password combination'
      render :new
    end
  end

  def clearance_check user
    if !user.activated_at?
      flash[:error] = 'Account not activated: check your email for the activation link'
      validate_user false
    elsif user.suspension
      flash[:error] = 'Account suspended'
      validate_user false
    else
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = 'Successfully logged in'
      redirect_back_or user
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'Successfully logged out'
    redirect_to root_path
  end

end
