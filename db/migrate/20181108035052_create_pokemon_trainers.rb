class CreatePokemonTrainers < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemon_trainers do |t|
      t.integer :trainer_id
      t.integer :pokemon_id

      t.timestamps
    end

    add_foreign_key :pokemon_trainers, :pokemons, column: :pokemon_id
    add_foreign_key :pokemon_trainers, :trainers, column: :trainer_id

    add_column :pokemon_trainers, :battle_count, :integer, default: 0
    add_column :pokemon_trainers, :win_count, :integer, default: 0
    add_column :pokemon_trainers, :lose_count, :integer, default: 0

  end
end
