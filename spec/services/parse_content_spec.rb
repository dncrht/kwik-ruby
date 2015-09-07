require 'rails_helper'

describe ParseContent do

  subject { described_class.new(text) }

  describe '#call' do
    context 'markdown' do
      let(:text) { '## Title' }

      before do
        ENV['PARSER'] = 'markdown'
      end

      it { expect(subject.call).to eq %(<h2 id="title">Title</h2>\n) }
    end

    context 'mediawiki' do
      let(:text) { '== Title ==' }

      before do
        ENV['PARSER'] = 'mediawiki'
      end

      it { expect(subject.call).to eq %(\n<h2>Title</h2>\n) }
    end
  end
end