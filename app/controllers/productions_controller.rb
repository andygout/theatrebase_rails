class ProductionsController < ApplicationController

  include Productions::DatesTableHelper
  include Productions::ViewsComponentsHelper
  include Shared::FormsHelper
  include Shared::ParamsHelper
  include Shared::ViewsComponentsHelper

  before_action :logged_in_user,            only: [:new, :create, :edit, :update, :destroy]
  before_action :not_suspended_user,        only: [:new, :create, :edit, :update, :destroy]
  before_action :get_new_production,        only: [:new, :create]
  before_action :get_production_by_id_url,  only: [:edit, :update, :destroy, :show]
  before_action :get_views_components,      only: [:new, :create, :edit, :update, :show]
  before_action :get_form_components,       only: [:new, :create, :edit, :update]
  before_action :get_show_components,       only: [:show]

  def new
    @page_title = 'New production'
  end

  def create
    @production = current_user.created_productions.build_with_user(production_params, current_user)
    if @production.save
      flash[:success] = 'Production created successfully'
      redirect_to production_path(@production.id, @production.url)
    else
      @page_title = 'New production'
      render :new
    end
  end

  def edit
    @page_title = "Edit production: #{@production.title}"
  end

  def update
    if @production.update(production_params)
      flash[:success] = 'Production updated successfully'
      redirect_to production_path(@production.id, @production.url)
    else
      @db_production = Production.find(params[:id])
      @production.url = @db_production.url
      @page_title = "Edit production: #{@db_production.title}"
      render :edit
    end
  end

  def destroy
    @production.destroy
    flash[:success] = 'Production deleted successfully'
    redirect_to productions_path
  end

  def show
    @page_title = @production.title
  end

  def index
    @productions = Production.order('COALESCE(alphabetise, title)')
    @production_index_table = get_production_index_table
  end

  private

    def production_params
      title = params[:production][:title]
      params[:production][:alphabetise] = get_alphabetise_value(title)
      params[:production][:url] = generate_url(title)
      nullify_unused_params

      params
        .require(:production)
        .permit(:title,
                :alphabetise,
                :url,
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

    def get_new_production
      @production = Production.new
    end

    def get_production_by_id_url
      @production = Production.find_by_id_and_url!(params[:id], params[:url])
    end

    def get_views_components
      @content_header = 'PRODUCTION'
    end

    def get_form_components
      get_created_updated_info @production
    end

    def get_show_components
      get_dates @production
    end

end
