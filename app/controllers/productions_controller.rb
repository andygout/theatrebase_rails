class ProductionsController < ApplicationController

  include Productions::DatesTableHelper
  include Productions::TheatreHelper
  include Shared::FormsHelper
  include Shared::ParamsHelper
  include Shared::ViewsComponentsHelper

  MODEL = 'Production'

  before_action :logged_in_user,                              only: [:new, :create, :edit, :update, :destroy]
  before_action :not_suspended_user,                          only: [:new, :create, :edit, :update, :destroy]
  before_action :get_production,                              only: [:new, :create, :edit, :update, :destroy, :show]
  before_action :get_page_title,                              only: [:new, :create, :edit, :show]
  before_action :get_browser_tab,                             only: [:edit, :show]
  before_action -> { get_content_header(MODEL) },             only: [:new, :create, :edit, :update, :show]
  before_action -> { get_created_updated_info(@production) }, only: [:new, :create, :edit, :update]

  def new
    @production.build_theatre
  end

  def create
    @production = current_user.created_productions.build_with_user(production_params, current_user)
    if @production.save
      flash[:success] = "#{MODEL} created successfully"
      redirect_to production_path(@production.id, @production.url)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @production.update(production_params)
      flash[:success] = "#{MODEL} updated successfully"
      redirect_to production_path(@production.id, @production.url)
    else
      @db_production = Production.find(params[:id])
      @production.url = @db_production.url
      @page_title = @db_production.title
      get_browser_tab
      render :edit
    end
  end

  def destroy
    @production.destroy
    flash[:success] = "#{MODEL} deleted successfully"
    redirect_to productions_path
  end

  def show
    get_dates_markup @production
    get_theatre_markup @production.theatre
  end

  def index
    @productions = Production.order('COALESCE(alphabetise, title)')
    get_production_index_table @productions
  end

  private

    def production_params
      nullify_unused_params
      amplify_production_attributes
      amplify_theatre_attributes

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
                :second_press_date,
                theatre_attributes: [:name, :alphabetise, :url, :creator_id, :updater_id])
        .merge(updater_id: current_user.id)
    end

    def nullify_unused_params
      [:press_date_tbc, :previews_only, :dates_info]
        .map { |p| params[:production][p] = nil if params[:production][p].to_i == 0 }

      [:press_date_wording, :dates_tbc_note, :dates_note]
        .map { |p| params[:production][p] = nil if params[:production][p].empty? }
    end

    def amplify_production_attributes
      title = params[:production][:title]
      params[:production][:alphabetise] = get_alphabetise_value(title)
      params[:production][:url] = generate_url(title)
    end

    def amplify_theatre_attributes
      theatre_name = params[:production][:theatre_attributes][:name]
      params[:production][:theatre_attributes].merge!(
          {
            alphabetise:  get_alphabetise_value(theatre_name),
            url:          generate_url(theatre_name),
            creator_id:   current_user.id,
            updater_id:   current_user.id
          }
        )
    end

    def get_production
      @production = params[:id] && params[:url] ?
        Production.find_by_id_and_url!(params[:id], params[:url]) :
        Production.new
    end

    def get_page_title
      @page_title = @production.title || "New #{MODEL.downcase}"
    end

    def get_browser_tab
      edit_page = ['edit', 'update'].include?(params[:action])
      @browser_tab = "#{'Edit: ' if edit_page}#{@page_title} (#{listing_dates(@db_production || @production)})"
    end

end
