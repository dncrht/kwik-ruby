class Repo

  class << self
    def create_test_fixtures(test_page, content)
      implementation.save(
        Page.new name: test_page, content: content
      )
    end

    def all(model)
      implementation.all model
    end

    def find_by(model, criteria)
      implementation.find_by model, criteria
    end

    def where(model, criteria)
      implementation.where model, criteria
    end

    def create(entity)
      implementation.create entity
    end

    def save(entity)
      implementation.save entity
    end

    def destroy(entity)
      implementation.destroy entity
    end

    private

    def implementation
      repo_implementation = ENV['REPO_IMPLEMENTATION'] || 'memory'
      ('Repo::' << repo_implementation.classify).constantize.new
    end
  end
end
