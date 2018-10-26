class CreatePokemons < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemons do |t|
      t.string :name, limit: 45, null: false
      t.integer :level, null: false, default: 1
      t.integer :max_health_point, null: false
      t.integer :current_health_point, null: false
      t.integer :attack, null: false
      t.integer :defence, null: false
      t.integer :speed, null: false
      t.integer :current_experience, null: false, default: 0

      t.timestamps
    end
    add_index :pokemons, :name, unique: true
    add_column :pokemons, :pokedex_id, :integer, null: :false
    add_foreign_key :pokemons, :pokedexes, column: :pokedex_id
  end
end
