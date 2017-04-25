class Repo
  class Filesystem

    def find_by(model, criteria)
      path = path_for(model.name) << criteria[:name]
      return unless File.exist?(path)
      file = File.open path, 'r'
      content = file.read
      file.close
      model.new(name: criteria[:name], content: content)
    end

    def save(entity)
      directory = path_for(entity.class.name)
      FileUtils.mkdir_p directory #mkdir_p avoids exception if directory exists

      path = directory << entity.name
      file = File.open path, 'w'
      file.write entity.content
      file.close
    end

    def destroy(entity)
      path = path_for(entity.class.name) << entity.name
      File.delete(path) if File.exist?(path) && entity.name != Rails.application.config.MAIN_PAGE
    end

    def where(model, criteria)
      name = criteria[:name]
      content = criteria[:content]

      if name.present?
        return Dir.entries(path_for(model.name)).sort.map do |file|
          file if file.downcase.include? name.downcase
        end.compact.tap { |search_names| search_names << name if name == Rails.application.config.ALL_PAGE }
      elsif content.present?
        search_content = Hash.new { |h, k| h[k] = [] }
        results = `cd "#{path_for(model.name)}"; grep '#{content}' *` #TODO case insensitive search
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
      Dir.entries(path_for(model.name)).sort.map do |file|
        if file[0, 1] != '.' && file != Rails.application.config.MAIN_PAGE
          file
        end
      end.compact
    end

    private

    def path_for(model)
      "#{Rails.root}/#{model.tableize}/"
    end
  end
end
