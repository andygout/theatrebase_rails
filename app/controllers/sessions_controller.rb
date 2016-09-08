class SessionsController < ApplicationController

  before_action :get_new_session_page_title

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      clearance_check user
    else
      flash.now[:error] = 'INVALID EMAIL-PASSWORD COMBINATION'
      render :new
    end
  end

  def clearance_check user
    if !user.activated_at?
      flash[:error] = 'ACCOUNT NOT ACTIVATED: CHECK YOUR EMAIL FOR THE ACTIVATION LINK'
      validate_user false
    elsif user.suspension
      flash[:error] = 'ACCOUNT SUSPENDED'
      validate_user false
    else
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = 'SUCCESSFULLY LOGGED IN'
      redirect_back_or user
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'SUCCESSFULLY LOGGED OUT'
    redirect_to root_path
  end

  private

    def get_new_session_page_title
      @page_title = 'Log in'
    end

end
