class Pokemon < ApplicationRecord
  belongs_to :pokedex
  has_many :pokemon_skills
  has_many :skills, through: :pokemon_skills

  validates :name, uniqueness: {scope: [:pokedex_id]}, length: {maximum: 45}, presence: true
  validates :pokedex_id, presence: true

  validates :max_health_point, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true, on: :update
  validates :current_health_point, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :max_health_point }, presence: true, on: :update
  validates :current_experience, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :attack, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true, on: :update
  validates :defence, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true, on: :update
  validates :speed, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true, on: :update
  validates :level, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true, on: :update
end
