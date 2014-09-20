class ParseContent
  def initialize(text)
    @text = text
  end

  def call
    case ENV['parser']
    when 'markdown'
      Kramdown::Document.new(@text).to_html
    else
      WikiCloth::Parser.new(data: '__NOTOC__' << @text).to_html(noedit: true)
    end
  end
end
