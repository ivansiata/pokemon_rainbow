class PokemonTrainer < ApplicationRecord
  belongs_to :trainer
  belongs_to :pokemon

  validates :pokemon_id, presence: true, uniqueness: true
  validate :pokemon_trainer_must_be_less_or_equal_to_five

  def pokemon_trainer_must_be_less_or_equal_to_five
    if PokemonTrainer.where(trainer_id: self.trainer_id).count >= 5
      errors.add(:trainer_id, " already had 5 pokemons")
    end
  end
end
