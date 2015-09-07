class ParseContent
  def initialize(text)
    @text = text
  end

  def call
    case ENV['PARSER']
    when 'mediawiki'
      WikiCloth::Parser.new(data: '__NOTOC__' << @text).to_html(noedit: true)
    else
      Kramdown::Document.new(@text).to_html
    end
  end
end
