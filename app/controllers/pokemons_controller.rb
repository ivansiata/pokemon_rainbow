class PokemonsController < ApplicationController
  include PokemonsHelper
  def index
    @pokemons = Pokemon.order(id: :asc).paginate(page: params[:page], per_page:5)
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokemon List", pokemons_path, title: "Pokemon List"
  end

  def new
    @pokemon = Pokemon.new
    @pokemon_skills = PokemonSkill.new
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokemon List", pokemons_path, title: "Back to Pokemon List"
    add_breadcrumb "New Pokemon", new_pokemon_path, title: "New Pokemon"
  end

  def create
    @pokemon = Pokemon.new(pokemon_params)

    @pokemon.max_health_point = @pokemon.pokedex.base_health_point
    @pokemon.current_health_point = @pokemon.pokedex.base_health_point
    @pokemon.attack = @pokemon.pokedex.base_attack
    @pokemon.defence = @pokemon.pokedex.base_defence
    @pokemon.speed = @pokemon.pokedex.base_speed

    if @pokemon.valid?
      @pokemon.save
      flash[:success] = "Pokemon #{@pokemon.name} created!"
      redirect_to pokemon_path(@pokemon)
    else
      render 'new'
    end
  end

  def create_pokemon_skill
    @pokemon_skills = PokemonSkill.new(pokemon_skill_params)
    @pokemon = Pokemon.find(params[:id])
    if params[:pokemon_skill][:skill_id].present?
      @pokemon_skills.pokemon_id = params[:id]
      @pokemon_skills.current_pp = @pokemon_skills.skill.max_pp

      if @pokemon_skills.save
        flash[:success] = "Pokemon Skill #{@pokemon_skills.skill.name} Added!"
        redirect_to pokemon_path(params[:id])
      else
        @options_for_skills = Skill.where(element_type: @pokemon.pokedex.element_type).map do |p|
          [p.name, p.id]
        end
        render 'show'
      end

    else
      @options_for_skills = Skill.where(element_type: @pokemon.pokedex.element_type).map do |p|
          [p.name, p.id]
        end
        flash.now[:danger] = "Skill cannot be empty"
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
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokemon List", pokemons_path, title: "Back to Pokemon List"
    add_breadcrumb @pokemon.name, pokemon_path(@pokemon)
  end

  def edit
    @pokemon = Pokemon.find(params[:id])
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokemon List", pokemons_path, title: "Back to Pokemon List"
    add_breadcrumb @pokemon.name, edit_pokemon_path(@pokemon)
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

  def heal_all
    pokemonOnGoing = []
    PokemonBattle.where(state: "ongoing").each do |p|
      pokemonOnGoing << p.pokemon1.id
      pokemonOnGoing << p.pokemon2.id
    end
    pokemonsHealedId = Pokemon.all.ids - pokemonOnGoing
    pokemonsHealedId.each do |id|
      pokemonsHealed = Pokemon.find(id)
      pokemonsHealed.current_health_point = Pokemon.find(id).max_health_point

      pokemonsHealed.pokemon_skills.each do |pokemon_skill|
        pokemon_skill.current_pp = pokemon_skill.skill.max_pp
        pokemon_skill.save
      end
      pokemonsHealed.save
    end
    flash[:success] = "All Pokemon Healed Up!"
    redirect_to pokemons_path
  end

  def heal
    @pokemon = Pokemon.find(params[:id])
    pokemon1IdList = PokemonBattle.where(state: "ongoing").map do |pokemon|
      pokemon.pokemon1_id
    end
    pokemon2IdList = PokemonBattle.where(state: "ongoing").map do |pokemon|
      pokemon.pokemon2_id
    end

    if !pokemon1IdList.include?(@pokemon.id) && !pokemon2IdList.include?(@pokemon.id)
      @pokemon.current_health_point = @pokemon.max_health_point

      @pokemon.pokemon_skills.each do |pokemon_skill|
        pokemon_skill.current_pp = pokemon_skill.skill.max_pp
        pokemon_skill.save
      end
      @pokemon.save
      redirect_to pokemon_path(@pokemon)
    else
      @pokemon_skills = PokemonSkill.new
       @options_for_skills = Skill.where(element_type: @pokemon.pokedex.element_type).map do |p|
         [p.name, p.id]
       end
      flash.now[:danger] = "Pokemon still in ongoing battle"
      render 'show'
    end
  end

end
