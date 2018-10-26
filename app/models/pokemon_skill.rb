class PokemonSkill < ApplicationRecord
  belongs_to :pokemon
  belongs_to :skill

  validates :skill_id, uniqueness: { scope: [:pokemon_id] }
end
