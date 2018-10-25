class CreatePokedexes < ActiveRecord::Migration[5.2]
  def change
    create_table :pokedexes do |t|
      t.string :name, limit: 45, null: false
      t.integer :base_health_point, null: false
      t.integer :base_attack, null: false
      t.integer :base_defence, null: false
      t.integer :base_speed, null: false
      t.string :element_type, null: false
      t.string :image_url

      t.timestamps
    end

    add_index :pokedexes, :name, unique: true
  end
end
