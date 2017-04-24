require 'rails_helper'

describe MainController do

  let(:test_page) { 'XyzTestPage' }
  let(:content) { 'unparsed xyztest content' }
  let(:html_content) { "<p>unparsed xyztest content</p>" }

  before do
    Repo.create_test_fixtures test_page, content
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials 'user', 'password'
  end

  describe '#show' do
    before { get :show, params }

    context 'Main page' do
      let(:params) { nil }

      it { expect(assigns(:page).title).to eq 'Main page' }
      it { expect(assigns(:page).content).to be_present }
      it { expect(response).to render_template(:show) }
    end

    context 'any Page' do
      let(:params) { {params: {page: test_page}} }

      it { expect(assigns(:page).title).to eq test_page }
      it { expect(assigns(:page).content).to eq content }
      it { expect(assigns(:parsed_content).strip).to eq html_content }
      it { expect(response).to render_template(:show) }
    end

    context 'a Page with spaces' do
      let(:params) { {params: {page: 'Page with spaces'}} }

      it { expect(assigns(:page).title).to eq 'Page with spaces' }
      it { expect(response).to render_template(:show) }
    end

    context 'an unexisting page' do
      let(:params) { {params: {page: 'unexisting'}} }

      it { expect(assigns(:terms)).to eq 'unexisting' }
      it { expect(assigns(:page).title).to eq 'unexisting' }
      it { expect(assigns(:page).content).to eq "Page does not exist. Click on the button above to create it." }
      it { expect(assigns(:parsed_content).strip).to eq "<p>Page does not exist. Click on the button above to create it.</p>" }
      it { expect(response).to render_template(:show) }
    end
  end

  describe '#show_all' do
    before { get :show_all, params: {page: Rails.application.config.ALL_PAGE} }

    it { expect(assigns(:all_pages)).to include test_page }
    it { expect(response).to render_template(:show_all) }
  end

  describe '#edit' do
    before { get :edit, params }

    context 'not allowed to edit All' do
      let(:params) { {params: {page: Rails.application.config.ALL_PAGE}} }

      it { expect(response).to redirect_to(show_all_path) }
    end

    context 'opening a missing page' do
      let(:params) { {params: {page: 'Missing'}} }

      it { expect(assigns(:page).content).to eq '' }
      it { expect(assigns(:parsed_content).strip).to eq '' }
      it { expect(response).to render_template(:edit) }
    end

    context 'opening the page for edition' do
      let(:params) { {params: {page: test_page}} }

      it { expect(assigns(:page).content).to eq content }
      it { expect(assigns(:parsed_content).strip).to eq html_content }
      it { expect(response).to render_template(:edit) }
    end

    context 'not allowed to update All' do
      let(:params) { {params: {page: Rails.application.config.ALL_PAGE}} }

      it { expect(response).to redirect_to(show_all_path) }
    end
  end

  describe '#preview' do
    before { put :preview, params: {page: test_page, content: content} }

    it { expect(assigns(:page).content).to eq content }
    it { expect(assigns(:parsed_content).strip).to eq html_content }
    it { expect(response).to render_template(:edit) }
  end

  describe '#update' do
    before { put :update, params: {page: test_page, content: content} }

    it { expect(response).to redirect_to(show_path(test_page)) }
  end

  describe '#delete' do
    before { delete :destroy, params }

    context 'not allowed the deletion of the Main page' do
      let(:params) { {params: {page: Rails.application.config.MAIN_PAGE}} }

      it { expect(response).to redirect_to(root_path) }
    end

    context 'delete a page' do
      let(:params) { {params: {page: test_page}} }

      it { expect(response).to redirect_to(root_path) }
    end
  end

  describe '#search' do
    before { get :search, params }

    context 'search for terms' do
      let(:params) { {params: {terms: 'xyztest'}} }

      it { expect(assigns(:terms)).to eq 'xyztest' }
      it { expect(assigns(:page).title).to eq 'Main page' }
      it { expect(response).to render_template(:search) }
    end

    context 'open a new page for creation' do
      let(:params) { {params: {terms: 'content', commit: 'Create'}} }

      it { expect(response).to redirect_to(edit_path('content')) }
    end
  end

  describe '#basic_auth' do
    before { request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials 'user', '' }

    it 'rejects access to show' do
      get :show, params: {page: 'Page'}
      expect(response.status).to eq 401
    end

    it 'rejects access to show_all' do
      get :show_all, params: {page: Rails.application.config.ALL_PAGE}
      expect(response.status).to eq 401
    end

    it 'rejects access to edit' do
      get :edit, params: {page: 'Page'}
      expect(response.status).to eq 401
    end

    it 'rejects access to preview' do
      put :preview, params: {page: 'Page'}
      expect(response.status).to eq 401
    end

    it 'rejects access to update' do
      put :update, params: {page: 'Page'}
      expect(response.status).to eq 401
    end

    it 'rejects access to destroy' do
      delete :destroy, params: {page: 'Page'}
      expect(response.status).to eq 401
    end

    it 'rejects access to search' do
      get :search
      expect(response.status).to eq 401
    end
  end
end
