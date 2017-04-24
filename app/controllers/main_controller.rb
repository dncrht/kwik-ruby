class MainController < ApplicationController

  before_action :basic_auth
  before_action :cannot_edit_All, only: %i(edit update)

  def show
    @page = Repo.find_by Page, name: page_name

    if @page
      @editable = true
    else
      @page = Page.new name: page_name
      @terms = @page.name
      @page.content = Rails.application.config.NO_PAGE_MESSAGE
    end

    @parsed_content = ParseContent.new(@page.content).call
  end

  def show_all
    @all_pages = Repo.all Page
    @page = Page.new name: Rails.application.config.ALL_PAGE
  end

  def edit
    @page = Repo.find_by Page, name: page_name

    unless @page
      @page = Page.new name: page_name
    end

    @parsed_content = ParseContent.new(@page.content).call
  end

  def preview
    @page = Page.new name: page_name, content: params[:content]

    @parsed_content = ParseContent.new(@page.content).call
    render :edit
  end

  def update
    page = Page.new name: page_name, content: params[:content]

    Repo.save page
    redirect_to show_path(page.name)
  end

  def destroy
    page = Page.new name: page_name

    Repo.destroy page
    redirect_to root_path
  end

  def search
    @page = Page.new name: page_name
    @terms = params[:terms]

    if params[:commit] == 'Create'
      redirect_to edit_path(@terms)
      return
    end

    @search_names = Repo.where Page, name: @terms

    @search_content = Repo.where Page, content: @terms
  end

  private

  # Performs user authentication.
  #
  def basic_auth
    authenticate_or_request_with_http_basic do |user, password|
      Rails.application.config.AUTHORIZED_USERS[user] == password
    end
  end

  def page_name
    params[:page] || Rails.application.config.MAIN_PAGE
  end

  # Prevents All from being edited.
  # It is a special page, not to be found in the repo.
  #
  def cannot_edit_All
    if page_name == Rails.application.config.ALL_PAGE
      redirect_to show_all_path
    end
  end
end
