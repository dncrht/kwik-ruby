require 'spec_helper'

describe MainController do

  before :all do
    Kwik::Application.config.PAGES_PATH = "#{Rails.root}/spec/pages"
  end

  before do
    File.open("#{Kwik::Application.config.PAGES_PATH}/Page", 'w') { |f| f.write 'unparsed content' } unless File.exist? "#{Kwik::Application.config.PAGES_PATH}/Page"
    File.open("#{Kwik::Application.config.PAGES_PATH}/Main_page", 'w') { |f| f.write 'unparsed main content' } unless File.exist? "#{Kwik::Application.config.PAGES_PATH}/Main_page"

    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials 'user', 'password'
  end

  context 'get pages' do

    it 'unauthorized' do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials 'user', ''

      get :show

      response.status.should eq 401
    end

    it 'Main page' do
      get :show

      assigns(:page).to_s.should eq 'Main_page'
      assigns(:page).title.should eq 'Main page'
      assigns(:page).content.should eq 'unparsed main content'
      assigns(:headings).should eq []
      assigns(:parsed_content).should eq "<p>unparsed main content</p>\n"
      response.should render_template(:show)
    end

    it 'any Page' do
      get :show, page: 'Page'

      assigns(:page).to_s.should eq 'Page'
      assigns(:page).title.should eq 'Page'
      assigns(:page).content.should eq 'unparsed content'
      assigns(:headings).should eq []
      assigns(:parsed_content).should eq "<p>unparsed content</p>\n"
      response.should render_template(:show)
    end

    it 'a Page with spaces' do
      get :show, page: 'Page with spaces'

      assigns(:page).to_s.should eq 'Page_with_spaces'
      assigns(:page).title.should eq 'Page with spaces'
      response.should render_template(:show)
    end

    it 'an unexisting page' do
      get :show, page: 'unexisting'

      assigns(:terms).should eq 'unexisting'
      assigns(:page).to_s.should eq 'unexisting'
      assigns(:page).title.should eq 'unexisting'
      assigns(:page).content.should eq "Page doesn't exist. Click on the button above to create it."
      assigns(:headings).should eq []
      assigns(:parsed_content).should eq "<p>Page doesn't exist. Click on the button above to create it.</p>\n"
      response.should render_template(:show)
    end

    it 'All' do
      get :show_all, page: 'All'

      assigns(:all_pages).should eq ['Page']
      response.should render_template(:show_all)
    end
  end

  context 'edit pages' do

    it 'should not allow to edit All' do
      get :edit, page: 'All'

      response.should redirect_to(show_all_path)
    end

    it 'should open the page for edition' do
      get :edit, page: 'Page'

      assigns(:page).content.should eq 'unparsed content'
      assigns(:headings).should eq []
      assigns(:parsed_content).should eq "<p>unparsed content</p>\n"
      response.should render_template(:edit)
    end

    it 'should not allow to update All' do
      put :edit, page: 'All'

      response.should redirect_to(show_all_path)
    end

    it 'should show an update preview' do
      put :update, page: 'Page', content: 'unparsed content', preview: true

      assigns(:page).content.should eq 'unparsed content'
      assigns(:headings).should eq []
      assigns(:parsed_content).should eq "<p>unparsed content</p>\n"
      response.should render_template(:edit)
    end

    it 'should update the page contents' do
      put :update, page: 'Page', content: 'unparsed content'

      response.should redirect_to(show_path('Page'))
    end
  end

  context 'delete pages' do

    it 'should not allow the deletion of the Main page' do
      delete :destroy, page: 'Main_page'

      response.should redirect_to(root_path)
    end

    it 'should delete a page' do
      delete :destroy, page: 'Page'

      response.should redirect_to(root_path)
    end
  end

  context 'search facility' do

    it 'should search for terms' do
      get :search, terms: 'content'

      assigns(:terms).should eq 'content'
      assigns(:page).title.should eq 'Main page'

      response.should render_template(:search)
    end

    it 'should open a new page for creation' do
      get :search, terms: 'content', commit: 'Create'

      response.should redirect_to(edit_path('content'))
    end
  end
end