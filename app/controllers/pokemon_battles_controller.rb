class PokemonBattlesController < ApplicationController
  include PokemonBattlesHelper

  def index
    @pokemon_battles = PokemonBattle.paginate(page: params[:page], per_page:5).order('created_at DESC')
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokemon Battle List", pokemon_battles_path, title: "Pokemon Battle List"
  end

  def new
    @pokemon_battle = PokemonBattle.new
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokemon Battle List", pokemon_battles_path, title: "Back to Pokemon Battle List"
    add_breadcrumb "New Pokemon Battle", new_pokemon_battle_path, title: "New Pokemon Battle"
  end

  def create
    @pokemon_battle = PokemonBattle.new(pokemon_battle_params)
    @pokemon_battle.battle_type = params[:commit]

    @pokemon_battle.current_turn = 1
    @pokemon_battle.state = "ongoing"

    if @pokemon_battle.pokemon1.present? && @pokemon_battle.pokemon1.present?
      @pokemon_battle.pokemon1_max_health_point = @pokemon_battle.pokemon1.max_health_point
      @pokemon_battle.pokemon2_max_health_point = @pokemon_battle.pokemon2.max_health_point
    end

    if @pokemon_battle.valid?

      if @pokemon_battle.pokemon1.pokemon_trainer.present?
        pokemon_trainer = @pokemon_battle.pokemon1.pokemon_trainer
        pokemon_trainer.battle_count = pokemon_trainer.battle_count + 1
        pokemon_trainer.save
      end
      @pokemon_battle.save
      if @pokemon_battle.battle_type == 'auto'
        autoBattleEngine = AiBattleEngine.new(@pokemon_battle)
        autoBattleEngine.auto_battle!
      end
      redirect_to pokemon_battle_path(@pokemon_battle)
    else
      render 'new'
    end
  end

  def show
    @pokemon_battle = PokemonBattle.find(params[:id])
    @options_for_skills1 = @pokemon_battle.pokemon1.skills.map do |skill| [skill.name, skill.id] end
    @options_for_skills2 = @pokemon_battle.pokemon2.skills.map do |skill| [skill.name, skill.id] end

    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokemon Battle List", pokemon_battles_path, title: "Back to Pokemon Battle List"
    add_breadcrumb "Battle", pokemon_battle_path(@pokemon_battle), title: "Pokemon Battle"

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
        if @pokemon_battle.battle_type == "vs_ai" && @pokemon_battle.pokemon_winner_id.nil?
          aiTurn = AiBattleEngine.new(@pokemon_battle)
          aiTurn.ai_turn!
        end
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

  def log
    @pokemon_battle_logs = PokemonBattleLog.where(pokemon_battle_id: params[:id])
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Battle", pokemon_battle_path(@pokemon_battle_logs.first.pokemon_battle_id), title: "Back to Pokemon Battle"
    add_breadcrumb "Battle Log"
  end

  def auto_battle
    @pokemon_battle = PokemonBattle.find(params[:id])
    @pokemon_battle.battle_type = "auto"
    autoBattleEngine = AiBattleEngine.new(@pokemon_battle)
    autoBattleEngine.auto_battle!

    redirect_to pokemon_battle_path(@pokemon_battle)
  end
end
