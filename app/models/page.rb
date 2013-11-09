class Page

  attr_reader :name, :title, :name_matches, :content_matches
  attr_accessor :content

  def initialize(name)
    @name = name.gsub ' ', '_'
    @title = name.gsub '_', ' '
  end

  def to_s
    @name
  end

  def exist?
    File.exist? path
  end

  def path
    "#{Kwik::Application.config.PAGES_PATH}/#{@name}"
  end

  def load(show_or_edit = :for_show)
    if exist?
      file = File.open path, 'r'
      @content = file.read
      file.close
    else
      if show_or_edit == :for_show
        @content = "Page doesn't exist. Click on the button above to create it."
      else
        @content = 'Start here to write the page content.'
      end
    end
  end

  def save
    FileUtils.mkdir_p Kwik::Application.config.PAGES_PATH #mkdir_p avoids exception if directory exists
    file = File.open path, 'w'
    file.write @content
    file.close
  end

  def destroy
    File.delete(path) if exist? && @name != 'Main_page'
  end

  def search_names(terms)
    @name_matches = []
    Dir.entries(Kwik::Application.config.PAGES_PATH).sort.each do |file|
      if file.downcase.include? terms.downcase
        @name_matches << file
      end
    end

    @name_matches << terms if terms == 'All'
  end

  def search_content(terms)
    @content_matches = Hash.new { |h, k| h[k] = [] } #http://stackoverflow.com/questions/2698460/strange-ruby-behavior-when-using-hash-new
    results = `cd "#{Kwik::Application.config.PAGES_PATH}"; grep '#{terms}' *` #TODO case insensitive search
    results.split("\n").each do |result|
      page, matching_line = result.split(':', 2)
      @content_matches[page] << matching_line << "\n"
    end
  end

  def self.all
    all_pages = []
    Dir.entries(Kwik::Application.config.PAGES_PATH).sort.each do |file|
      if file[0, 1] != '.' && file != 'Main_page'
        all_pages << file
      end
    end
    all_pages
  end
end