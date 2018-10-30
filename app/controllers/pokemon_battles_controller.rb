class PokemonBattlesController < ApplicationController
  include PokemonBattlesHelper

  def index
    @pokemon_battles = PokemonBattle.paginate(page: params[:page], per_page:5)
  end

  def new
    @pokemon_battle = PokemonBattle.new
  end

  def create
    @pokemon_battle = PokemonBattle.new(pokemon_battle_params)
    @pokemon_battle.current_turn = 1
    @pokemon_battle.state = "ongoing"

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

  end

  def destroy
    @pokemon_battles = PokemonBattle.find(params[:id])
    @pokemon_battles.destroy

    redirect_to pokemon_battles_path
  end

  def update
    @pokemon_battle = PokemonBattle.find(params[:id])
    commit = params[:commit]

    if @pokemon_battle.current_turn % 2 != 0
      attacker = @pokemon_battle.pokemon1
      defender = @pokemon_battle.pokemon2
    else
      attacker = @pokemon_battle.pokemon2
      defender = @pokemon_battle.pokemon1
    end


    if commit == "Attack"

      if attacker.skills.ids.include?(params[:attack][:skill_id].to_i)
        if attacker.pokemon_skills.find_by(skill_id: params[:attack][:skill_id]).current_pp > 0
            attacker.pokemon_skills.find_by(skill_id: params[:attack][:skill_id]).current_pp = attacker.pokemon_skills.find_by(skill_id: params[:attack][:skill_id]).current_pp - 1
            defender.current_health_point =  defender.current_health_point - PokemonBattleCalculator.calculate_damage(attacker, defender, attacker.skills.find(params[:attack][:skill_id]))
            @pokemon_battle.current_turn = @pokemon_battle.current_turn + 1
            attacker.pokemon_skills.find_by(skill_id: params[:attack][:skill_id]).current_pp = attacker.pokemon_skills.find_by(skill_id: params[:attack][:skill_id]).current_pp - 1


            attacker.save
            attacker.pokemon_skills.save
            require 'pry'
            binding.pry


            defender.save
            @pokemon_battle.save
            redirect_to pokemon_battle_path(@pokemon_battle)
        else
          @options_for_skills1 = @pokemon_battle.pokemon1.skills.map do |skill| [skill.name, skill.id] end
          @options_for_skills2 = @pokemon_battle.pokemon2.skills.map do |skill| [skill.name, skill.id] end
          flash.now[:danger] = "Skill Must be Chosen."
          render 'show'
        end
      else
        @options_for_skills1 = @pokemon_battle.pokemon1.skills.map do |skill| [skill.name, skill.id] end
        @options_for_skills2 = @pokemon_battle.pokemon2.skills.map do |skill| [skill.name, skill.id] end
        flash.now[:danger] = "Skill Must be Chosen."
        render 'show'
      end



    end

  end


end
