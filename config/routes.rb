Rails.application.routes.draw do
  get 'pokemon_battles/index'
  get 'pokemon_battles/new'
  get 'pokemon_battles/show'
  root 'static_pages#home'
  resources :pokedexes
  resources :skills
  resources :pokemons do
    post :create_pokemon_skill, on: :member
    delete 'destroy_pokemon_skill/:skill_id', to: 'pokemons#destroy_pokemon_skill', as: "destroy_pokemon_skill", on: :member
  end
  resources :pokemon_battles
end
