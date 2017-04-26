class Page < ActiveRecord::Migration[5.0]
  def change
    create_table :pages do |t|
      t.text :name
      t.text :content
    end

    add_index :pages, :name
  end
end
