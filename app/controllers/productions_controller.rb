class ProductionsController < ApplicationController

  before_action :get_production,      only: [:edit, :update, :destroy, :show]
  before_action :logged_in_user,      only: [:new, :create, :edit, :update, :destroy]
  before_action :not_suspended_user,  only: [:new, :create, :edit, :update, :destroy]

  def new
    @production = Production.new
  end

  def create
    @production = Production.new(production_params)
    if @production.save
      flash[:success] = "Production created successfully: #{@production.title}"
      redirect_to @production
    else
      render :new
    end
  end

  def edit
    @page_title = @production.title
  end

  def update
    if @production.update(production_params)
      flash[:success] = "Production updated successfully: #{@production.title}"
      redirect_to production_path(@production)
    else
      @page_title = Production.find(params[:id]).title
      render :edit
    end
  end

  def destroy
    @production.destroy
    flash[:success] = "Production deleted successfully: #{@production.title}"
    redirect_to productions_path
  end

  def show
  end

  def index
    @productions = Production.all
  end

  private

    def production_params
      params
        .require(:production)
        .permit(:title)
    end

    def get_production
      @production = Production.find(params[:id])
    end

end
