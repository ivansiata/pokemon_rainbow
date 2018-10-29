class PokemonBattlesController < ApplicationController
  include PokemonBattlesHelper
  def index
    @pokemon_battles = PokemonBattle.paginate(page: params[:page], per_page:5)
  end

  def new
    @pokemon_battles = PokemonBattle.new
  end

  def create
    @pokemon_battles = PokemonBattle.new(pokemon_battle_params)
    @pokemon_battles.current_turn = 1
    @pokemon_battles.state = "ongoing"

    if @pokemon_battles.valid?
      @pokemon_battles.save
      redirect_to pokemon_battle_path(@pokemon_battles)
    else
      render 'new'
    end
  end

  def show
    @pokemon_battles = PokemonBattle.find(params[:id])
    @options_for_skills1 = @pokemon_battles.pokemon1.skills.map do |skill| [skill.name, skill.id] end
    @options_for_skills2 = @pokemon_battles.pokemon2.skills.map do |skill| [skill.name, skill.id] end
  end

  def destroy
    @pokemon_battles = PokemonBattle.find(params[:id])
    @pokemon_battles.destroy

    redirect_to pokemon_battles_path
  end
end
