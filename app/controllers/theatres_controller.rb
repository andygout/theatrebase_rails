class TheatresController < ApplicationController

  include Shared::FormsHelper
  include Shared::ParamsHelper

  before_action :logged_in_user,            only: [:edit, :update, :destroy]
  before_action :not_suspended_user,        only: [:edit, :update, :destroy]
  before_action :get_theatre
  before_action :get_page_title,            only: [:edit, :show]
  before_action :get_browser_tab,           only: [:edit, :show]
  before_action :get_views_components,      only: [:edit, :update, :show]
  before_action :get_form_components,       only: [:edit, :update]

  def edit
  end

  def update
    if @theatre.update(theatre_params)
      flash[:success] = 'Theatre updated successfully'
      redirect_to theatre_path(@theatre)
    else
      @db_theatre = Theatre.find(params[:id])
      @page_title = "#{@db_theatre.name}"
      get_browser_tab
      render :edit
    end
  end

  def destroy
    @theatre.destroy
    flash[:success] = 'Theatre deleted successfully'
    redirect_to root_path
  end

  def show
  end

  private

    def theatre_params
      params[:theatre][:alphabetise] = get_alphabetise_value(params[:theatre][:name])

      params
        .require(:theatre)
        .permit(:name,
                :alphabetise)
        .merge(updater_id: current_user.id)
    end

    def get_theatre
      @theatre = Theatre.find(params[:id])
    end

    def get_page_title
      @page_title = "#{@theatre.name}"
    end

    def get_browser_tab
      @browser_tab = params[:action] == 'show' ?
        "#{@page_title} (theatre)" :
        "Edit: #{@page_title} (theatre)"
    end

    def get_views_components
      @content_header = 'THEATRE'
    end

    def get_form_components
      get_created_updated_info @theatre
    end

end
