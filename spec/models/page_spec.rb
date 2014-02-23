require 'spec_helper'

describe Page do

  let(:page_file) { "#{Rails.root}/spec/pages/Page" }
  let(:content) { 'unparsed content' }
  let(:page) { Page.new('Page') }

  before do
    File.open(page_file, 'w') { |f| f.write content } unless File.exist? page_file
  end

  it 'should return a page object' do
    expect(page).to be_a Page
  end

  it 'should return the name of the page' do
    expect(page.to_s).to eq 'Page'
  end

  it 'should return the path of the page' do
    expect(page.path).to eq page_file
  end

  it 'should load an existing page' do
    page.load
    expect(page.content).to eq content
  end

  it "should load a page that doesn't exists in show mode" do
    File.delete(page_file)
    page.load(:for_show)
    expect(page.content).to eq "Page doesn't exist. Click on the button above to create it."
  end

  it "should load a page that doesn't exist in edit mode" do
    File.delete(page_file)
    page.load(:for_edit)
    expect(page.content).to eq 'Start here to write the page content.'
  end

  it 'should return all pages' do
    expect(Page.all).to eq ['Page']
  end

  it 'should return pages that match the name' do
    expect(page.search_names 'content').to eq []
  end

  it "should return All although it doesn't exist" do
    expect(page.search_names 'All').to eq ['All']
  end

  it 'should return pages that match the content' do
    expect(page.search_content 'content').to eq({'Main_page' => ['unparsed main content', "\n"], 'Page' => ['unparsed content', "\n"]})
  end

  it 'should save' do
    page.content = 'new test text'
    page.save
    expect(File.open(page_file, 'r').read).to eq 'new test text'
  end

  it 'should destroy' do
    page.destroy
    expect(File.exist?(page_file)).to be_false
  end

  it 'should not fail if destroy' do
    File.delete(page_file)
    page.destroy
    expect(File.exist?(page_file)).to be_false
  end
end
