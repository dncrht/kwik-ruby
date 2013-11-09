class ErrorsController < ApplicationController

  def not_found
    @page = Page.new('Not Found')

    render status: 404
  end

  def server_error
    @page = Page.new('Internal server error')

    render status: 500
  end
end