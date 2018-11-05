class CreatePokemonBattleLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemon_battle_logs do |t|
      t.integer :pokemon_battle_id, null: false
      t.integer :turn, null: false
      t.integer :skill_id
      t.integer :damage, null: false, default: 0
      t.integer :attacker_id, null: false
      t.integer :attacker_current_health_point, null: false
      t.integer :defender_id, null: false
      t.integer :defender_current_health_point, null: false
      t.string :action_type, null: false

      t.timestamps
    end

     add_foreign_key :pokemon_battle_logs, :pokemon_battles, column: :pokemon_battle_id
     add_foreign_key :pokemon_battle_logs, :skills, column: :skill_id
     add_foreign_key :pokemon_battle_logs, :pokemons, column: :attacker_id
     add_foreign_key :pokemon_battle_logs, :pokemons, column: :defender_id
  end
end
