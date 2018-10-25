class Skill < ApplicationRecord
  extend Enumerize
  validates :name, presence: true, uniqueness:true
  validates :power, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :max_pp, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :element_type, presence: true

  enumerize :element_type, in: [:normal, :fire, :fighting, :water, :flying, :grass, :poison, :electric, :ground, :phychic, :rock, :ice, :bug,
    :dragon, :ghost, :dark, :steel, :fairy]
end
