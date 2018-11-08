class Trainer < ApplicationRecord
  has_many :pokemon_trainers
  has_many :pokemons, through: :pokemon_trainers

  validates :email, uniqueness: {:case_sensitive => false}, presence: true
  has_secure_password
end
