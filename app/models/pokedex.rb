class Pokedex < ApplicationRecord
  extend Enumerize
  validates :name, uniqueness: true, length: {maximum: 45}, presence: true
  validates :base_health_point, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true
  validates :base_attack, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true
  validates :base_defence, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true
  validates :base_speed, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true

  enumerize :element_type, in: [:normal, :fire, :fighting, :water, :flying, :grass, :poison, :electric, :ground, :phychic, :rock, :ice, :bug,
    :dragon, :ghost, :dark, :steel, :fairy]
end
