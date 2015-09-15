class ProductionsController < ApplicationController

  def index
    @productions = Production.all
  end

  def new
    @production = Production.new
  end

  def create
    Production.create(production_params)
    redirect_to productions_path
  end

  def show
    @production = Production.find(params[:id])
  end

  def edit
    @production = Production.find(params[:id])
  end

  def update
    @production = Production.find(params[:id])
    @production.update(production_params)
    redirect_to production_path(@production)
  end

  def destroy
    @production = Production.find(params[:id])
    @production.destroy
    flash[:notice] = 'Production deleted successfully'
    redirect_to productions_path
  end

  def production_params
    params.require(:production).permit(:title)
  end

end