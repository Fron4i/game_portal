class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description
      t.date :released_at

      t.timestamps
    end

    add_index :games, :slug, unique: true
    add_index :games, :title
  end
end
