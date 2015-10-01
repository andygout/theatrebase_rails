class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "User created successfully: #{@user.name} (#{@user.email})"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @page_title = @user.name
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated successfully: #{@user.name}"
      redirect_to @user
    else
      @page_title = User.find(params[:id]).name
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

    def user_params
      params.require(:user).permit( :name,
                                    :email,
                                    :password,
                                    :password_confirmation
                                  )
    end

end