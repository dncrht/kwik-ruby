module WikiCloth
  class WikiBuffer
    def gen_heading(hnum,title)
      "<h#{hnum}>#{title}</h#{hnum}>\n"
    end
  end
end
