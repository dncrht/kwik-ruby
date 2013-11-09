require 'spec_helper'

describe MainHelper do

  it 'should not render less than 4 headings' do
    format_headings(['1. Foo', '2. Bar', '2.1. Baz']).should be_nil
  end

  it 'should render the headings in an unordered list' do
    out = <<-EOS.gsub("\n", '')
<ul class="breadcrumb" id="jumpers">
<li>1. Foo</li>
<li>2. Bar</li>
<li>2.1. Baz</li>
<li>2.2. Qux</li>
</ul>
EOS

    format_headings(['1. Foo', '2. Bar', '2.1. Baz', '2.2. Qux']).should eq out
  end
end