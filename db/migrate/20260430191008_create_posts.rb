class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.integer :kind, null: false, default: 0
      t.datetime :published_at
      t.references :game, null: false, foreign_key: true
      t.references :author, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, :published_at
    add_index :posts, [:game_id, :published_at]
  end
end
