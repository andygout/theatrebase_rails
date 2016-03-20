class ProductionsController < ApplicationController

  include ProductionsShowHelper

  before_action :get_production,      only: [:edit, :update, :destroy, :show]
  before_action :logged_in_user,      only: [:new, :create, :edit, :update, :destroy]
  before_action :not_suspended_user,  only: [:new, :create, :edit, :update, :destroy]
  before_action :get_page_header,     only: [:new, :edit, :show]

  def new
    @production = Production.new
  end

  def create
    @production = current_user.created_productions.build_with_user(production_params, current_user)
    if @production.save
      flash[:success] = 'Production created successfully'
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
      flash[:success] = 'Production updated successfully'
      redirect_to production_path(@production)
    else
      @page_title = Production.find(params[:id]).title
      render :edit
    end
  end

  def destroy
    @production.destroy
    flash[:success] = 'Production deleted successfully'
    redirect_to productions_path
  end

  def show
    @dates = create_dates_markup(@production).html_safe
  end

  def index
    @productions = Production.all
  end

  private

    def production_params
      nullify_unused_params

      params
        .require(:production)
        .permit(:title,
                :first_date,
                :press_date,
                :last_date,
                :press_date_tbc,
                :previews_only,
                :dates_info,
                :press_date_wording,
                :dates_tbc_note,
                :dates_note,
                :second_press_date)
        .merge(updater_id: current_user.id)
    end

    def nullify_unused_params
      [:press_date_tbc, :previews_only, :dates_info]
        .map { |p| params[:production][p] = nil if params[:production][p].to_i == 0 }

      [:press_date_wording, :dates_tbc_note, :dates_note]
      .map { |p| params[:production][p] = nil if params[:production][p].empty? }
    end

    def get_production
      @production = Production.find(params[:id])
    end

    def get_page_header
      @content_header = "<p class='content-label content-header'>PRODUCTION</p>".html_safe
    end

end
