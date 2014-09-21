class MainController < ApplicationController

  before_filter :basic_auth, :set_page_by_name
  before_filter :cannot_edit_All, only: %i(edit update)

  def show
    @page.load :for_show

    @terms = @page.name unless @page.exist?

    parse_content
  end

  def show_all
    @all_pages = Page.all
  end

  def edit
    @page.load :for_edit

    parse_content
  end

  def preview
    @page.content = params[:content]

    parse_content
    render :edit
  end

  def update
    @page.content = params[:content]

    @page.save
    redirect_to show_path(@page)
  end

  def destroy
    @page.destroy

    redirect_to root_path
  end

  def search
    @terms = params[:terms]

    if params[:commit] == 'Create'
      redirect_to edit_path(@terms)
      return
    end

    @search_names = @page.search_names(@terms)

    @search_content = @page.search_content(@terms)
  end

  private

  # Performs user authentication.
  #
  def basic_auth
    authenticate_or_request_with_http_basic do |user, password|
      Rails.application.config.AUTHORIZED_USERS[user] == password
    end
  end

  # Sets page name on page object.
  #
  def set_page_by_name
    name = params[:page] || Rails.application.config.MAIN_PAGE

    @page = Page.new(name)
  end

  # Prevents All from being edited.
  # It is a special page, not to be found in the filesystem.
  #
  def cannot_edit_All
    if @page.name == Rails.application.config.ALL_PAGE
      redirect_to show_all_path
    end
  end

  def parse_content
    @parsed_content = ParseContent.new(@page.content).call
  end
end
