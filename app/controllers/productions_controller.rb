class ProductionsController < ApplicationController

  def index
    @productions = Production.all
  end

end