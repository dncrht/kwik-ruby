class Repo
  class Memory

    @@store = {}

    def find_by(model, criteria)
      content = store(model.name)[criteria[:name]]
      return unless content
      model.new(name: criteria[:name], content: content)
    end

    def save(entity)
      store(entity.class.name)[entity.name] = entity.content
    end

    def destroy(entity)
      store(entity.class.name).delete(entity.name) if entity.name != Rails.application.config.MAIN_PAGE
    end

    def where(model, criteria)
      name = criteria[:name]
      content = criteria[:content]

      if name.present?
        return store(model.name).keys.sort.map do |page|
          page if page.downcase.include? name.downcase
        end.compact.tap { |search_names| search_names << name if name == Rails.application.config.ALL_PAGE }
      elsif content.present?
        search_content = Hash.new { |h, k| h[k] = [] }
        store(model.name).each do |page_name, page_content|
          next unless page_content.include? content
          page_content.split("\n").each do |matching_line|
            next unless matching_line.include? content
            search_content[page_name] << matching_line << "\n"
          end
        end
        search_content
      else
        []
      end
    end

    def all(model)
      store(model.name).keys.sort.map do |name|
        name if name != Rails.application.config.MAIN_PAGE
      end.compact
    end

    private

    def store(model_name)
      s = self.class.class_variable_get(:@@store)
      unless s.include? model_name
        s[model_name] = {}
      end
      s[model_name]
    end
  end
end
