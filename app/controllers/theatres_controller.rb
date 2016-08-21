class TheatresController < ApplicationController

  include Shared::FormsHelper
  include Shared::ParamsHelper
  include Shared::ViewsComponentsHelper

  MODEL = 'Theatre'

  before_action :logged_in_user,                            only: [:edit, :update, :destroy]
  before_action :not_suspended_user,                        only: [:edit, :update, :destroy]
  before_action :get_theatre
  before_action :get_page_title,                            only: [:edit, :show]
  before_action -> { get_browser_tab(MODEL) },              only: [:edit, :show]
  before_action -> { get_content_header(MODEL) },           only: [:edit, :update, :show]
  before_action -> { get_created_updated_info(@theatre) },  only: [:edit, :update]

  def edit
  end

  def update
    if @theatre.update(theatre_params)
      flash[:success] = "#{MODEL} updated successfully"
      redirect_to theatre_path(@theatre.url)
    else
      @db_theatre = Theatre.find_by_url!(params[:url])
      @theatre.url = @db_theatre.url
      @page_title = "#{@db_theatre.name}"
      get_browser_tab(MODEL)
      render :edit
    end
  end

  def destroy
    @theatre.destroy
    if @theatre.errors.empty?
      flash[:success] = "#{MODEL} deleted successfully"
      redirect_to root_path
    else
      get_page_title
      get_browser_tab(MODEL)
      flash[:error] = @theatre.errors.messages[:base][0]
      redirect_to theatre_path(@theatre.url)
    end
  end

  def show
    get_production_index_table @theatre.productions
  end

  private

    def theatre_params
      amplify_theatre_attributes

      params
        .require(:theatre)
        .permit(:name,
                :alphabetise,
                :url)
        .merge(updater_id: current_user.id)
    end

    def amplify_theatre_attributes
      name = params[:theatre][:name]
      params[:theatre][:alphabetise] = get_alphabetise_value(name)
      params[:theatre][:url] = generate_url(name)
    end

    def get_theatre
      @theatre = Theatre.find_by_url!(params[:url])
    end

    def get_page_title
      @page_title = "#{@theatre.name}"
    end

end
