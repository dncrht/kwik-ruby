require 'rails_helper'

describe Page do

  let(:page_file) { "#{Rails.root}/spec/pages/Page" }
  let(:content) { 'unparsed content' }
  let(:page) { Page.new('Page') }

  before do
    File.open(page_file, 'w') { |f| f.write content } unless File.exist? page_file
  end

  it 'returns a page object' do
    expect(page).to be_a Page
  end

  it 'returns the name of the page' do
    expect(page.to_s).to eq 'Page'
  end

  it 'returns the path of the page' do
    expect(page.path).to eq page_file
  end

  it 'loads an existing page' do
    page.load
    expect(page.content).to eq content
  end

  it "loads a page that doesn't exists in show mode" do
    File.delete(page_file)
    page.load(:for_show)
    expect(page.content).to eq "Page doesn't exist. Click on the button above to create it."
  end

  it "loads a page that doesn't exist in edit mode" do
    File.delete(page_file)
    page.load(:for_edit)
    expect(page.content).to eq 'Start here to write the page content.'
  end

  it 'returns all pages' do
    expect(Page.all).to eq ['Page']
  end

  it 'returns pages that match the name' do
    expect(page.search_names 'content').to eq []
  end

  it "returns All although it doesn't exist" do
    expect(page.search_names 'All').to eq ['All']
  end

  it 'returns pages that match the content' do
    expect(page.search_content 'content').to eq({Rails.application.config.MAIN_PAGE => ['unparsed main content', "\n"], 'Page' => ['unparsed content', "\n"]})
  end

  it 'saves' do
    page.content = 'new test text'
    page.save
    expect(File.open(page_file, 'r').read).to eq 'new test text'
  end

  it 'destroys' do
    page.destroy
    expect(File.exist?(page_file)).to be_falsey
  end

  it 'does not fail on destroy' do
    File.delete(page_file)
    page.destroy
    expect(File.exist?(page_file)).to be_falsey
  end
end
