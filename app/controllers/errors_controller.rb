class ErrorsController < ApplicationController

  def error_404
    @page_title = '404 Error: Not Found'
    render :status => 404
  end

  def error_500
    @page_title = '500 Error: Internal Server Error'
    render :status => 500
  end

end
