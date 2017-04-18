class Page

  attr_reader :name, :title
  attr_accessor :content

  def initialize(attributes = {})
    name = attributes[:name].to_s

    @name = name.gsub ' ', '_'
    @title = name.gsub '_', ' '
    @content = attributes[:content].to_s
  end
end
