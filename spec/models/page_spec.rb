require 'spec_helper'

describe Page do

  before :all do
    Kwik::Application.config.PAGES_PATH = "#{Rails.root}/spec/pages"
    @page_path = "#{Kwik::Application.config.PAGES_PATH}/Page"
    @page = Page.new('Page')
  end

  before do
    unless File.exist? @page_path
      File.open(@page_path, 'w') { |f| f.write 'unparsed content' }
    end
  end

  it 'should return a page object' do
    @page.should be_an_instance_of Page
  end

  it 'should return the name of the page' do
    @page.to_s.should eq @page.name
    @page.to_s.should eq 'Page'
  end

  it 'should return the path of the page' do
    @page.path.should eq @page_path
  end

  it 'should load an existing page' do
    @page.load
    @page.content.should eq 'unparsed content'
  end

  it "should load a page that doesn't exists in show mode" do
    File.delete(@page_path)
    @page.load(:for_show)
    @page.content.should eq "Page doesn't exist. Click on the button above to create it."
  end

  it "should load a page that doesn't exists in edit mode" do
    File.delete(@page_path)
    @page.load(:for_edit)
    @page.content.should eq 'Start here to write the page content.'
  end

  it 'should return all pages' do
    all_pages = Page.all
    all_pages.should be_an_instance_of Array
    all_pages.should eq ['Page']
  end

  it 'should return pages that match the name' do
    @page.search_names 'content'
    @page.name_matches.should be_an_instance_of Array
    @page.name_matches.should eq []
  end

  it 'should return pages that match the content' do
    @page.search_content 'content'
    @page.content_matches.should be_an_instance_of Hash
    @page.content_matches.should eq({'Main_page' => ['unparsed main content', "\n"], 'Page' => ['unparsed content', "\n"]})
  end

  it 'should save' do
    @page.content = 'new test text'
    @page.save
    File.open(@page_path, 'r').read.should eq 'new test text'
  end

  it 'should destroy' do
    @page.destroy
    File.exist?(@page_path).should_not be_true
  end

  it 'should not fail if destroy' do
    File.delete(@page_path)
    @page.destroy
    File.exist?(@page_path).should_not be_true
  end
end