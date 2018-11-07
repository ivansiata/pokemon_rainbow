class CreatePokemonBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemon_battles do |t|
      t.integer :current_turn, null: false
      t.string :state, limit: 45, null: false
      t.integer :pokemon_winner_id
      t.integer :pokemon_loser_id
      t.integer :experience_gain
      t.integer :pokemon1_max_health_point
      t.integer :pokemon2_max_health_point

      t.timestamps
    end
    add_column :pokemon_battles, :pokemon1_id, :integer, null: false
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon1_id

    add_column :pokemon_battles, :pokemon2_id, :integer, null: false
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon2_id

    add_column :pokemon_battles, :battle_type, :string, null: false
  end
end
