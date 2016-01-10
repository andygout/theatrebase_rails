class PermissionsController < ApplicationController

  before_action :get_user
  before_action :logged_in_user
  before_action :permissions_user

  def edit
    @user.admin || @user.build_admin
    @page_title = @user.name
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Permissions updated successfully: #{@user.name}"
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
        .permit(admin_attributes: [:status])
    end

    def get_user
      @user = User.find_by(id: params[:id])
    end

    def permissions_user
      validate_user valid_permissions_user? @user
    end

    def validate_user user_valid
      unless user_valid
        flash[:error] = 'Access denied'
        redirect_to root_path
      end
    end

end
