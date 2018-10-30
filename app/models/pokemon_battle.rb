class PokemonBattle < ApplicationRecord
  extend Enumerize
  belongs_to :pokemon1, class_name: 'Pokemon'
  belongs_to :pokemon2, class_name: 'Pokemon'

  validate :pokemon_id_battle_must_be_different
  validate :pokemons_current_hp_must_greater_than_zero
  validate :pokemon_id_ongoing_must_be_less_than_two
  validate :battle_skill_must_be_equal_to_pokemon_skills, on: :update
  enumerize :state, in: [:ongoing, :finished]


  private

  def pokemon_id_battle_must_be_different
    if pokemon1_id == pokemon2_id
      errors.add(:pokemon_id, "can't be same!")
    end
  end

  def pokemons_current_hp_must_greater_than_zero
    if self.pokemon1.current_health_point < 1
      errors.add(:pokemon_1, "HP is zero")
    end

    if self.pokemon2.current_health_point < 1
      errors.add(:pokemon_2, "HP is zero")
    end
  end

  def pokemon_id_ongoing_must_be_less_than_two

    if PokemonBattle.where(pokemon1_id: [self.pokemon1_id, self.pokemon2_id], state: "ongoing").count >=1 || PokemonBattle.where(pokemon2_id: [self.pokemon1_id, self.pokemon2_id], state: "ongoing").count >=1
      errors.add(:pokemon, "1 or Pokemon 2 still on going")
    end
  end

  def battle_skill_must_be_equal_to_pokemon_skills
    if !PokemonSkill.where(pokemon_id: self.pokemon1.id).ids.include? skill_id
      errors.add(:skill_id, "error")
    end
  end
end
