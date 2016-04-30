class ProductionsController < ApplicationController

  include Shared::ViewsComponentsHelper
  include Shared::FormsHelper
  include Shared::ParamsHelper
  include Productions::DatesShowHelper

  before_action :logged_in_user,        only: [:new, :create, :edit, :update, :destroy]
  before_action :not_suspended_user,    only: [:new, :create, :edit, :update, :destroy]
  before_action :get_production,        only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :get_views_components,  only: [:new, :create, :edit, :update, :show]
  before_action :get_form_components,   only: [:new, :create, :edit, :update]
  before_action :get_show_components,   only: [:show]

  def new
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
      redirect_to @production
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
  end

  def index
    @productions = Production.order('COALESCE(alphabetise, title)')
  end

  private

    def production_params
      params[:production][:alphabetise] = extract_alphabetise_value(params[:production][:title])
      nullify_unused_params

      params
        .require(:production)
        .permit(:title,
                :alphabetise,
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
      @production = params[:id] ? Production.find(params[:id]) : Production.new
    end

    def get_views_components
      get_content_header 'production'
    end

    def get_form_components
      get_created_updated_info @production
    end

    def get_show_components
      get_dates @production
    end

end
