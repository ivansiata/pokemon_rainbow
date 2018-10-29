class PokemonsController < ApplicationController
  include PokemonsHelper
  def index
    @pokemons = Pokemon.paginate(page: params[:page], per_page:5)
  end

  def new
    @pokemon = Pokemon.new
    @pokemon_skills = PokemonSkill.new
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)

    if @pokemon.valid?
      @pokemon.max_health_point = @pokemon.pokedex.base_health_point
      @pokemon.current_health_point = @pokemon.pokedex.base_health_point
      @pokemon.attack = @pokemon.pokedex.base_attack
      @pokemon.defence = @pokemon.pokedex.base_defence
      @pokemon.speed = @pokemon.pokedex.base_speed
      @pokemon.save
      flash[:success] = "Pokemon #{@pokemon.name} created!"
      redirect_to pokemon_path(@pokemon)
    else
      render 'new'
    end
  end

  def create_pokemon_skill
    @pokemon_skills = PokemonSkill.new(pokemon_skill_params)
    @pokemon_skills.pokemon_id = params[:id]
    @pokemon_skills.current_pp = @pokemon_skills.skill.max_pp
    @pokemon = Pokemon.find(params[:id])
    if @pokemon_skills.save
      flash[:success] = "Pokemon Skill #{@pokemon_skills.skill.name} Added!"
      redirect_to pokemon_path(params[:id])
    else
      @options_for_skills = Skill.where(element_type: @pokemon.pokedex.element_type).map do |p|
        [p.name, p.id]
      end
      render 'show'
    end

  end

  def destroy_pokemon_skill
    @pokemon_skills = PokemonSkill.find_by(pokemon_id: params[:id], skill_id: params[:skill_id])
    @pokemon_skills.destroy
    flash[:success] = "Pokemon Skill #{@pokemon_skills.skill.name} Destroyed!"
    redirect_to pokemon_path(@pokemon_skills.pokemon_id)
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    @pokemon_skills = PokemonSkill.new

    @options_for_skills = Skill.where(element_type: @pokemon.pokedex.element_type).map do |p|
      [p.name, p.id]
    end
  end

  def edit
    @pokemon = Pokemon.find(params[:id])
  end

  def update
    @pokemon = Pokemon.find(params[:id])

    if @pokemon.update_attributes(pokemon_edit_params)
      flash[:success] = "Pokemon #{@pokemon.name} updated!"
      redirect_to pokemon_path(@pokemon)
    else
      render 'edit'
    end
  end

  def destroy
    @pokemon = Pokemon.find(params[:id])
    @pokemon.destroy
    flash[:success] = "Pokemon #{@pokemon.name} deleted!"
    redirect_to pokemons_path
  end

end
