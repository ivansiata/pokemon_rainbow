class PokemonSkill < ApplicationRecord
  belongs_to :pokemon
  belongs_to :skill

  validates :skill_id, uniqueness: { scope: [:pokemon_id] }
  validates :current_pp, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :skill_must_be_less_or_equal_to_four
  validate :current_pp_not_greater_than_max_pp
  validate :element_type_of_skill_must_be_equal_to_pokedex

  def skill_must_be_less_or_equal_to_four
    if PokemonSkill.where(pokemon_id: self.pokemon_id).count >= 4
      errors.add(:pokemon_id, " already had 4 skills")
    end
  end

  def current_pp_not_greater_than_max_pp
    if self.current_pp.present?
      if self.current_pp > self.skill.max_pp
        errors.add(:current_pp, "cannot be greater than Max PP")
      end
    end
  end

  def element_type_of_skill_must_be_equal_to_pokedex
    if !Skill.where(element_type: self.pokemon.pokedex.element_type).ids.include? skill_id
      errors.add(:skill_id, "error")
    end
  end

end
