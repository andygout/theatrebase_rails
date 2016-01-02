class ProductionsController < ApplicationController

  before_action :logged_in_user,  only: [:new, :create, :edit, :destroy]

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
    @production = Production.find(params[:id])
    @page_title = @production.title
  end

  def update
    @production = Production.find(params[:id])
    if @production.update(production_params)
      flash[:success] = "Production updated successfully: #{@production.title}"
      redirect_to production_path(@production)
    else
      @page_title = Production.find(params[:id]).title
      render :edit
    end
  end

  def destroy
    @production = Production.find(params[:id])
    @production.destroy
    flash[:success] = "Production deleted successfully: #{@production.title}"
    redirect_to productions_path
  end

  def show
    @production = Production.find(params[:id])
  end

  def index
    @productions = Production.all
  end

  private

    def production_params
      params.require(:production).permit(:title)
    end

end
