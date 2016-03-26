class SuspensionStatusController < ApplicationController

  include StatusHelper

  before_action :get_user
  before_action :logged_in_user
  before_action :not_suspended_user
  before_action :suspension_status_assignor
  before_action :get_form_components,       only: [:edit]

  def edit
    @user.suspension || @user.build_suspension
  end

  def update
    @user.update(user_status_params(:suspension))
    flash[:success] = 'Suspension status updated successfully'
    redirect_to @user
  end

    private

    def get_user
      @user = User.find(params[:user_id])
    end

    def suspension_status_assignor
      validate_user valid_suspension_status_assignor? @user
    end

    def get_form_components
      get_status_edit_components :suspension
    end

end
