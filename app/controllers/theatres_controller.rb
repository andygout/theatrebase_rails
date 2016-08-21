class TheatresController < ApplicationController

  include Shared::FormsHelper
  include Shared::ParamsHelper
  include Shared::ViewsComponentsHelper

  MODEL = 'Theatre'

  before_action :logged_in_user,                              only: [:edit, :update, :destroy]
  before_action :not_suspended_user,                          only: [:edit, :update, :destroy]
  before_action :get_theatre
  before_action -> { get_page_title(MODEL, @theatre.name) },  only: [:edit, :update, :show]
  before_action -> { get_browser_tab(MODEL) },                only: [:edit, :update, :show]
  before_action -> { get_content_header(MODEL) },             only: [:edit, :update, :show]
  before_action -> { get_created_updated_info(@theatre) },    only: [:edit, :update]

  def edit
  end

  def update
    if @theatre.update(theatre_params)
      flash[:success] = success_msg(MODEL, 'updated')
      redirect_to theatre_path(@theatre.url)
    else
      @theatre.url = params[:url]
      render :edit
    end
  end

  def destroy
    @theatre.destroy
    if @theatre.errors.empty?
      flash[:success] = success_msg(MODEL, 'deleted')
      redirect_to root_path
    else
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

end
