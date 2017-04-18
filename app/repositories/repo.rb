Repo = Struct.new(:implementation) do

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
end
