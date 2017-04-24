class Repo
  class Database

    class Page < ActiveRecord::Base; end

    def find_by(model, criteria)
      entity = ar_for(model).find_by criteria
      return unless entity
      model.new(name: entity.name, content: entity.content)
    end

    def save(entity)
      model = ar_for(entity.class)
      e = model.find_by(name: entity.name) || model.new
      e.attributes = {name: entity.name, content: entity.content}
      e.save
    end

    def destroy(entity)
      e = ar_for(entity.class).find_by(name: entity.name)
      e.destroy if e.present? && entity.name != Rails.application.config.MAIN_PAGE
    end

    def where(model, criteria)
      name = criteria[:name]
      content = criteria[:content]

      if name.present?
        return ar_for(model).where(name: name).all.map do |entity|
          entity if entity.name.downcase.include? name.downcase
        end.compact.tap { |search_names| search_names << name if name == Rails.application.config.ALL_PAGE }
      elsif content.present?
        search_content = Hash.new { |h, k| h[k] = [] }
        ar_for(model).where('content LIKE ?', "%#{content}%").all.each do |entity|
          entity['content'].split("\n").each do |matching_line|
            next unless matching_line.include? content
            search_content[entity.name] << matching_line << "\n"
          end
        end
        search_content
      else
        []
      end
    end

    def all(model)
      ar_for(model).all.map do |entity|
        name = entity.name
        if name != Rails.application.config.MAIN_PAGE
          name
        end
      end.compact
    end

    private

    def ar_for(model)
      "Repo::Database::#{model.name}".constantize
    end
  end
end
