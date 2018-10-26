class Pokemon < ApplicationRecord
  belongs_to :pokedex
  validates :name, uniqueness: true, length: {maximum: 45}, presence: true
  validates :pokedex_id, presence: true

  validates :max_health_point, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true, on: :update
  validates :current_health_point, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true, on: :update
  validates :attack, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true, on: :update
  validates :defence, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true, on: :update
  validates :speed, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, presence: true, on: :update
end
