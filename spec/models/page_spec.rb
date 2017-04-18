require 'rails_helper'

describe Page do

  describe '.new' do
    it 'sets the attributes' do
      page = Page.new name: 'Some P_A_G_E', content: 'idk'
      expect(page.name).to eq 'Some_P_A_G_E'
      expect(page.title).to eq 'Some P A G E'
      expect(page.content).to eq 'idk'
    end
  end
end
