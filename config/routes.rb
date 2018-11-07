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
  get '/heal_all', to: 'pokemons#heal_all', as: "heal_pokemons"
  get '/heal/:id', to: 'pokemons#heal', as: "heal_pokemon"

  resources :pokemon_battles do
    get '/log', to: 'pokemon_battles#log', as: "show_battle_log", on: :member
    get '/auto_battle', to: 'pokemon_battles#auto_battle', as: "auto_battle", on: :member
  end
end
