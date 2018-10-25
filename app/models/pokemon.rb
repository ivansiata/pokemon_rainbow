class Pokemon < ApplicationRecord
  belongs_to :pokedex
  validates :name, uniqueness: true, length: {maximum: 45}, presence: true
  validates :level, presence: true
  validates :max_health_point, presence: true
  validates :current_health_point, presence: true
  validates :attack, presence: true
  validates :defence, presence: true
  validates :speed, presence: true
  validates :current_experience, presence: true


end
