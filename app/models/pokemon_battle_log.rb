class PokemonBattleLog < ApplicationRecord
  belongs_to :pokemon_battle
  belongs_to :pokemon1, class_name: 'Pokemon', foreign_key: 'attacker_id'
  belongs_to :pokemon2, class_name: 'Pokemon', foreign_key: 'defender_id'
  belongs_to :skill, optional: true

  validates :pokemon_battle_id, presence: true
  validates :turn, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :damage, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :attacker_id, presence: true
  validates :attacker_current_health_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :defender_id, presence: true
  validates :defender_current_health_point, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :action_type, presence: true
end
