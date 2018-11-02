class PokemonBattlesController < ApplicationController
  include PokemonBattlesHelper

  def index
    @pokemon_battles = PokemonBattle.paginate(page: params[:page], per_page:5).order('created_at DESC')
  end

  def new
    @pokemon_battle = PokemonBattle.new
  end

  def create
    @pokemon_battle = PokemonBattle.new(pokemon_battle_params)
    @pokemon_battle.current_turn = 1
    @pokemon_battle.state = "ongoing"
    @pokemon_battle.pokemon1_max_health_point = @pokemon_battle.pokemon1.max_health_point
    @pokemon_battle.pokemon2_max_health_point = @pokemon_battle.pokemon2.max_health_point

    if @pokemon_battle.valid?
      @pokemon_battle.save
      redirect_to pokemon_battle_path(@pokemon_battle)
    else
      render 'new'
    end
  end

  def show
    @pokemon_battle = PokemonBattle.find(params[:id])
    @options_for_skills1 = @pokemon_battle.pokemon1.skills.map do |skill| [skill.name, skill.id] end
    @options_for_skills2 = @pokemon_battle.pokemon2.skills.map do |skill| [skill.name, skill.id] end

    @pokemon_battle.save

  end

  def destroy
    @pokemon_battles = PokemonBattle.find(params[:id])
    @pokemon_battles.destroy

    redirect_to pokemon_battles_path
  end

  def update
    @pokemon_battle = PokemonBattle.find(params[:id])
    commit = params[:commit]
    selectedSkill = params[:attack][:skill_id]
    pokemonId = params[:attack][:pokemon_id]

    battleEngine = BattleEngine.new(@pokemon_battle, pokemonId, commit, selectedSkill)

    if battleEngine.valid_next_turn?
      if battleEngine.next_turn!
        battleEngine.save!
        redirect_to pokemon_battle_path(@pokemon_battle)
      else
        flash.now[:danger] = battleEngine.errors.join("<br>").html_safe
        render 'show'
      end
    else
      flash.now[:danger] = battleEngine.errors.join("<br>").html_safe
      render 'show'
    end
  end


end
