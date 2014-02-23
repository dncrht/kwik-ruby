=begin
Copyright (c) 2010 Daniel Cruz Horts

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
=end

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
      Kwik::Application.config.AUTHORIZED_USERS[user] == password
    end
  end

  # Sets page name on page object.
  #
  def set_page_by_name
    name = params[:page] || 'Main_page'

    @page = Page.new(name)
  end

  # Prevents All from being edited.
  # It is a special page, not to be found in the filesystem.
  #
  def cannot_edit_All
    if @page.name == 'All'
      redirect_to show_all_path
    end
  end

  def parse_content
    @headings, @parsed_content = [], Marker.parse(@page.content).to_html
  end
end
