require 'spec_helper'

describe MainHelper do

  let(:output) do <<-EOS.gsub("\n", '')
<ul class="breadcrumb" id="jumpers">
<li>1. Foo</li>
<li>2. Bar</li>
<li>2.1. Baz</li>
<li>2.2. Qux</li>
</ul>
    EOS
  end

  it 'should not render less than 4 headings' do
    expect(helper.format_headings(['1. Foo', '2. Bar', '2.1. Baz'])).to be_nil
  end

  it 'should render the headings in an unordered list' do
    expect(helper.format_headings(['1. Foo', '2. Bar', '2.1. Baz', '2.2. Qux'])).to eq output
  end
end
