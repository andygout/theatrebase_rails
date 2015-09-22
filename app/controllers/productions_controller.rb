class ProductionsController < ApplicationController

  def index
    @productions = Production.all
  end

  def new
    @production = Production.new
  end

  def create
    @production = Production.create(production_params)
    flash[:success] = "Production created successfully: #{@production.title}"
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
    flash[:success] = "Production updated successfully: #{@production.title}"
    redirect_to production_path(@production)
  end

  def destroy
    @production = Production.find(params[:id])
    @production.destroy
    flash[:success] = "Production deleted successfully: #{@production.title}"
    redirect_to productions_path
  end

  private

    def production_params
      params.require(:production).permit(:title)
    end

end