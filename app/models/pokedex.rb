class Pokedex < ApplicationRecord
  extend Enumerize
  validates :name, uniqueness: true, length: {maximum: 45}
  validates :image_url, length: {maximum: 45}
  validates :base_health_point, numericality: { only_integer: true, allow_blank: true }
  validates :base_attack, numericality: { only_integer: true, allow_blank: true }
  validates :base_defence, numericality: { only_integer: true, allow_blank: true }
  validates :base_speed, numericality: { only_integer: true, allow_blank: true }

  enumerize :element_type, in: [:normal, :fire, :fighting, :water, :flying, :grass, :poison, :electric, :ground, :phychic, :rock, :ice, :bug,
    :dragon, :ghost, :dark, :steel, :fairy]
end
