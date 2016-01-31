class SuspensionStatusController < ApplicationController

  before_action :get_user
  before_action :logged_in_user
  before_action :not_suspended_user
  before_action :suspension_status_user

  def edit
    @user.suspension || @user.build_suspension
    @page_title = @user.name
  end

  def update
    params[:user][:suspension_attributes][:assignor_id] = current_user.id
    if @user.update(user_params)
      flash[:success] = "Suspension status updated successfully: #{@user.name}"
      redirect_to @user
    else
      @page_title = @user.name
      render :edit
    end
  end

    private

    def user_params
      params
        .require(:user)
        .permit(suspension_attributes: [:_destroy,
                                        :id,
                                        :assignor_id])
    end

    def get_user
      @user = User.find_by(id: params[:user_id])
    end

    def not_suspended_user
      validate_user not_suspended_user?
    end

    def suspension_status_user
      validate_user valid_suspension_status_user? @user
    end

    def validate_user user_valid
      unless user_valid
        flash[:error] = 'Access denied'
        redirect_to root_path
      end
    end

end
