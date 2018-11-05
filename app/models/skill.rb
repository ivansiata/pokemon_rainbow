class Skill < ApplicationRecord
  extend Enumerize
  has_many :pokemon_skills
  has_many :pokemons, through: :pokemon_skills
  has_many :pokemon_battle_logs

  validates :name, presence: true, uniqueness:true, length: {maximum: 45}
  validates :power, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :max_pp, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :element_type, presence: true, length: {maximum: 45}

  enumerize :element_type, in: [:normal, :fire, :fighting, :water, :flying, :grass, :poison, :electric, :ground, :psychic, :rock, :ice, :bug,
    :dragon, :ghost, :dark, :steel, :fairy]
end
