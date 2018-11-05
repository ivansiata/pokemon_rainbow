class Pokemon < ApplicationRecord
  belongs_to :pokedex
  has_many :pokemon_skills
  has_many :skills, through: :pokemon_skills
  has_many :pokemon_battles, class_name: 'PokemonBattle', foreign_key: 'pokemon1_id'
  has_many :pokemon_battles, class_name: 'PokemonBattle', foreign_key: 'pokemon2_id'

  has_many :wins, class_name: 'PokemonBattle', foreign_key: 'pokemon_winner_id'
  has_many :loses, class_name: 'PokemonBattle', foreign_key: 'pokemon_loser_id'

  has_many :pokemon_battle_logs, class_name: 'PokemonBattleLog', foreign_key: 'pokemon1_id'
  has_many :pokemon_battle_logs, class_name: 'PokemonBattleLog', foreign_key: 'pokemon2_id'

  validates :name, presence: true, uniqueness: {scope: [:pokedex_id]}, length: {maximum: 45}
  validates :pokedex_id, presence: true

  validates :max_health_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :current_health_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :current_health_point, numericality: { only_integer: true, less_than_or_equal_to: :max_health_point }, if: :max_health_point_present?
  validates :current_experience, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :attack, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :defence, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :speed, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  private

  def max_health_point_present?
    max_health_point.present?
  end
end
