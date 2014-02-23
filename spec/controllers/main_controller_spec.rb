require 'spec_helper'

Kwik::Application.config.PAGES_PATH = "#{Rails.root}/spec/pages"

describe MainController do

  let(:page_file) { "#{Kwik::Application.config.PAGES_PATH}/Page" }
  let(:main_page_file) { "#{Kwik::Application.config.PAGES_PATH}/Main_page" }
  let(:content) { 'unparsed content' }
  let(:html_content) { "<p>unparsed content</p>\n" }

  before do
    File.open(page_file, 'w') { |f| f.write content } unless File.exist? page_file
    File.open(main_page_file, 'w') { |f| f.write 'unparsed main content' } unless File.exist? main_page_file

    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials 'user', 'password'
  end

  describe '#show' do
    before { get :show, params }

    context 'Main page' do
      let(:params) { nil }

      it { assigns(:page).to_s.should eq 'Main_page' }
      it { assigns(:page).title.should eq 'Main page' }
      it { assigns(:page).content.should eq 'unparsed main content' }
      it { assigns(:headings).should eq [] }
      it { assigns(:parsed_content).should eq "<p>unparsed main content</p>\n" }
      it { response.should render_template(:show) }
    end

    context 'any Page' do
      let(:params) { {page: 'Page'} }

      it { assigns(:page).to_s.should eq 'Page' }
      it { assigns(:page).title.should eq 'Page' }
      it { assigns(:page).content.should eq content }
      it { assigns(:headings).should eq [] }
      it { assigns(:parsed_content).should eq html_content }
      it { response.should render_template(:show) }
    end

    context 'a Page with spaces' do
      let(:params) { {page: 'Page with spaces'} }

      it { assigns(:page).to_s.should eq 'Page_with_spaces' }
      it { assigns(:page).title.should eq 'Page with spaces' }
      it { response.should render_template(:show) }
    end

    context 'an unexisting page' do
      let(:params) { {page: 'unexisting'} }

      it { assigns(:terms).should eq 'unexisting' }
      it { assigns(:page).to_s.should eq 'unexisting' }
      it { assigns(:page).title.should eq 'unexisting' }
      it { assigns(:page).content.should eq "Page doesn't exist. Click on the button above to create it." }
      it { assigns(:headings).should eq [] }
      it { assigns(:parsed_content).should eq "<p>Page doesn't exist. Click on the button above to create it.</p>\n" }
      it { response.should render_template(:show) }
    end
  end

  describe '#show_all' do
    before { get :show_all, page: 'All' }

    it { assigns(:all_pages).should eq ['Page'] }
    it { response.should render_template(:show_all) }
  end

  describe '#edit' do
    before { get :edit, params }

    context 'not allowed to edit All' do
      let(:params) { {page: 'All'} }

      it { response.should redirect_to(show_all_path) }
    end

    context 'opening the page for edition' do
      let(:params) { {page: 'Page'} }

      it { assigns(:page).content.should eq content }
      it { assigns(:headings).should eq [] }
      it { assigns(:parsed_content).should eq html_content }
      it { response.should render_template(:edit) }
    end

    context 'not allowed to update All' do
      let(:params) { {page: 'All'} }

      it { response.should redirect_to(show_all_path) }
    end
  end

  describe '#preview' do
    before { put :preview, page: 'Page', content: content }

    it { assigns(:page).content.should eq content }
    it { assigns(:headings).should eq [] }
    it { assigns(:parsed_content).should eq html_content }
    it { response.should render_template(:edit) }
  end

  describe '#update' do
    before { put :update, page: 'Page', content: content }

    it { response.should redirect_to(show_path('Page')) }
  end

  describe '#delete' do
    before { delete :destroy, params }

    context 'not allowed the deletion of the Main page' do
      let(:params) { {page: 'Main_page'} }

      it { response.should redirect_to(root_path) }
    end

    context 'delete a page' do
      let(:params) { {page: 'Page'} }

      it { response.should redirect_to(root_path) }
    end
  end

  describe '#search' do
    before { get :search, params }

    context 'search for terms' do
      let(:params) { {terms: 'content'} }

      it { assigns(:terms).should eq 'content' }
      it { assigns(:page).title.should eq 'Main page' }
      it { response.should render_template(:search) }
    end

    context 'open a new page for creation' do
      let(:params) { {terms: 'content', commit: 'Create'} }

      it { response.should redirect_to(edit_path('content')) }
    end
  end

  describe '#basic_auth' do
    before { request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials 'user', '' }

    it 'should reject access to show' do
      get :show, page: 'Page'
      response.status.should eq 401
    end

    it 'should reject access to show_all' do
      get :show_all, page: 'All'
      response.status.should eq 401
    end

    it 'should reject access to edit' do
      get :edit, page: 'Page'
      response.status.should eq 401
    end

    it 'should reject access to preview' do
      put :preview, page: 'Page'
      response.status.should eq 401
    end

    it 'should reject access to update' do
      put :update, page: 'Page'
      response.status.should eq 401
    end

    it 'should reject access to destroy' do
      delete :destroy, page: 'Page'
      response.status.should eq 401
    end

    it 'should reject access to search' do
      get :search
      response.status.should eq 401
    end
  end
end
