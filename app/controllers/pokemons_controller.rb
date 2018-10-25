class PokemonsController < ApplicationController
  def index
    @pokemons = Pokemon.paginate(page: params[:page], per_page:5)
  end

  def new
    @pokemon = Pokemon.new
  end

  def create
    @pokemon = Pokemon.new
    @pokemon.max_health_point = @pokemon.pokedex.find(params[:pokedex_id]).base_health_point
    @pokemon.current_health_point = @pokemon.pokedex.find(params[:pokedex_id]).base_health_point
  end

  def show

  end
end
