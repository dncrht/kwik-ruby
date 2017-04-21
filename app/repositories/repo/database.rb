class Repo
  class Database

    def find_by(model, criteria)
      entity = db.select_one("SELECT * FROM #{model.name.tableize} WHERE name = '#{criteria[:name]}'")
      return unless entity
      model.new(name: criteria[:name], content: entity['content'])
    end

    def save(entity)
      existing_entity = db.select_one("SELECT * FROM #{entity.class.name.tableize} WHERE name = '#{entity.name}'")
      if existing_entity
        db.execute("UPDATE #{entity.class.name.tableize} SET content = '#{entity.content}' WHERE id = '#{existing_entity['id']}'")
      else
        db.execute("INSERT INTO #{entity.class.name.tableize}(name, content) VALUES ('#{entity.name}', '#{entity.content}')")
      end
    end

    def destroy(entity)
      db.execute("DELETE FROM #{entity.class.name.tableize} WHERE name = '#{entity.name}'")
    end

    def where(model, criteria)
      name = criteria[:name]
      content = criteria[:content]

      if name.present?
        return Dir.entries(path_for(model.name.tableize)).sort.map do |file|
          file if file.downcase.include? name.downcase
        end.compact.tap { |search_names| search_names << name if name == Rails.application.config.ALL_PAGE }
      elsif content.present?
        search_content = Hash.new { |h, k| h[k] = [] }
        results = `cd "#{path_for(model.name.tableize)}"; grep '#{content}' *` #TODO case insensitive search
        results.split("\n").each do |result|
          page, matching_line = result.split(':', 2)
          search_content[page] << matching_line << "\n"
        end
        search_content
      else
        []
      end
    end

    def all(model)
      entities = db.select_all("SELECT * FROM #{model.name.tableize}")
      entities.map do |entity|
        name = entity['name']
        if name != Rails.application.config.MAIN_PAGE
          name
        end
      end.compact
    end

    private

    def db
      ActiveRecord::Base.connection
    end
  end
end
