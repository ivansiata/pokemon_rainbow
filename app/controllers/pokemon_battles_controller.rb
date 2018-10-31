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

    if @pokemon_battle.current_turn % 2 != 0
      attacker = @pokemon_battle.pokemon1
      defender = @pokemon_battle.pokemon2
    else
      attacker = @pokemon_battle.pokemon2
      defender = @pokemon_battle.pokemon1
    end

    if attacker.id == pokemonId.to_i
      if commit == "Attack"

        if attacker.skills.ids.include?(selectedSkill.to_i)
          attackerSkill = attacker.pokemon_skills.find_by(skill_id: selectedSkill)

          if attackerSkill.current_pp > 0

              attackerSkill.current_pp = attackerSkill.current_pp - 1
              defender.current_health_point =  defender.current_health_point - PokemonBattleCalculator.calculate_damage(attacker, defender, attacker.skills.find(selectedSkill))
              defender.current_health_point = 0 if defender.current_health_point < 0
              @pokemon_battle.current_turn = @pokemon_battle.current_turn + 1

              if defender.current_health_point == 0
                @pokemon_battle.state = "finished"
                @pokemon_battle.pokemon_loser_id = defender.id
                @pokemon_battle.pokemon_winner_id = attacker.id

                experience_gain = PokemonBattleCalculator.calculate_experience(defender.level)
                attacker.current_experience = attacker.current_experience + experience_gain
                @pokemon_battle.experience_gain = experience_gain

                while PokemonBattleCalculator.level_up?(attacker.level, attacker.current_experience)
                  attacker.level = attacker.level + 1
                  output = PokemonBattleCalculator.calculate_level_up_extra_stats
                  attacker.max_health_point = attacker.max_health_point + output[:health_point]
                  attacker.attack = attacker.attack + output[:attack_point]
                  attacker.defence = attacker.defence + output[:defence_point]
                  attacker.speed = attacker.speed + output[:speed_point]
                end

              end

              attacker.save
              attackerSkill.save
              defender.save
              @pokemon_battle.save
              redirect_to pokemon_battle_path(@pokemon_battle)

          else

            flash.now[:danger] = "Skill PP is zero."
            render 'show'

          end
        else

          flash.now[:danger] = "Skill must be chosen."
          render 'show'

        end

      elsif commit == "Surrender"

         @pokemon_battle.pokemon_loser_id = attacker.id
         @pokemon_battle.pokemon_winner_id = defender.id
         @pokemon_battle.state = "finished"
         @pokemon_battle.current_turn = @pokemon_battle.current_turn + 1

         experience_gain = PokemonBattleCalculator.calculate_experience(attacker.level)
         defender.current_experience = defender.current_experience + experience_gain
         @pokemon_battle.experience_gain = experience_gain

         while PokemonBattleCalculator.level_up?(defender.level, defender.current_experience)

            defender.level = defender.level + 1
            output = PokemonBattleCalculator.calculate_level_up_extra_stats
            defender.max_health_point = defender.max_health_point + output[:health_point]
            defender.attack = defender.attack + output[:attack_point]
            defender.defence = defender.defence + output[:defence_point]
            defender.speed = defender.speed + output[:speed_point]

         end

         @pokemon_battle.save
         defender.save

         redirect_to pokemon_battle_path(@pokemon_battle)

      end
    else

      flash.now[:danger] = "Wrong pokemon turn"
      render 'show'
    end
  end


end
