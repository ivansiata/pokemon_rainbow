Rails.application.routes.draw do
  root 'static_pages#home'
  resources :pokedexes
  resources :skills
  resources :pokemons do
    post :create_pokemon_skill, on: :member
    delete 'destroy_pokemon_skill/:skill_id', to: 'pokemons#destroy_pokemon_skill', as: "destroy_pokemon_skill", on: :member
  end
end
