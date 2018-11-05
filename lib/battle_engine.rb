class BattleEngine
  attr_accessor :errors
  attr_accessor :stats

  def initialize(pokemon_battle, pokemonId, commit, selectedSkill)
    @pokemon_battle = pokemon_battle
    @pokemonId = pokemonId
    @commit = commit
    @errors = []
    @pokemon_battle_logs = PokemonBattleLog.new

    if @pokemon_battle.current_turn % 2 != 0
      @attacker = @pokemon_battle.pokemon1
      @defender = @pokemon_battle.pokemon2
    else
      @attacker = @pokemon_battle.pokemon2
      @defender = @pokemon_battle.pokemon1
    end

    @attackerSkill = @attacker.pokemon_skills.find_by(skill_id: selectedSkill)
  end

  def valid_next_turn?
    if @attacker.id == @pokemonId.to_i
      return true
    else
      @errors << "Invalid pokemon turn"
      return false
    end
  end

  def next_turn!
    if @commit == "Attack"
      if @attackerSkill.present?
          if @attackerSkill.current_pp > 0

              @attackerSkill.current_pp = @attackerSkill.current_pp - 1
              damage = PokemonBattleCalculator.calculate_damage(@attacker, @defender, @attackerSkill.skill)
              @defender.current_health_point =  @defender.current_health_point - damage
              @defender.current_health_point = 0 if @defender.current_health_point < 0
              @pokemon_battle.current_turn = @pokemon_battle.current_turn + 1

              if @defender.current_health_point == 0
                @pokemon_battle.state = "finished"
                @pokemon_battle.pokemon_loser_id = @defender.id
                @pokemon_battle.pokemon_winner_id = @attacker.id

                experience_gain = PokemonBattleCalculator.calculate_experience(@defender.level)
                @attacker.current_experience = @attacker.current_experience + experience_gain
                @pokemon_battle.experience_gain = experience_gain

                while PokemonBattleCalculator.level_up?(@attacker.level, @attacker.current_experience)
                  @attacker.level = @attacker.level + 1
                  output = PokemonBattleCalculator.calculate_level_up_extra_stats
                  @attacker.max_health_point = @attacker.max_health_point + output[:health_point]
                  @attacker.attack = @attacker.attack + output[:attack_point]
                  @attacker.defence = @attacker.defence + output[:defence_point]
                  @attacker.speed = @attacker.speed + output[:speed_point]
                  @stats << @attacker.max_health_point + output[:health_point]

                end
              end
              @pokemon_battle_logs.pokemon_battle_id = @pokemon_battle.id
              @pokemon_battle_logs.turn =  @pokemon_battle.current_turn - 1
              @pokemon_battle_logs.skill_id = @attackerSkill.skill.id
              @pokemon_battle_logs.damage = damage
              @pokemon_battle_logs.attacker_id = @attacker.id
              @pokemon_battle_logs.attacker_current_health_point = @attacker.current_health_point
              @pokemon_battle_logs.defender_id = @defender.id
              @pokemon_battle_logs.defender_current_health_point = @defender.current_health_point
              @pokemon_battle_logs.action_type = @commit
              return true
          else
            @errors << "Skill PP is empty"
            return false
          end
        else
          @errors << "Skill is not selected"
          return false
        end

      elsif @commit == "Surrender"

         @pokemon_battle.pokemon_loser_id = @attacker.id
         @pokemon_battle.pokemon_winner_id = @defender.id
         @pokemon_battle.state = "finished"
         @pokemon_battle.current_turn = @pokemon_battle.current_turn + 1

         experience_gain = PokemonBattleCalculator.calculate_experience(@attacker.level)
         @defender.current_experience = @defender.current_experience + experience_gain
         @pokemon_battle.experience_gain = experience_gain

         while PokemonBattleCalculator.level_up?(@defender.level, @defender.current_experience)

            @defender.level = @defender.level + 1
            output = PokemonBattleCalculator.calculate_level_up_extra_stats
            @defender.max_health_point = @defender.max_health_point + output[:health_point]
            @defender.attack = @defender.attack + output[:attack_point]
            @defender.defence = @defender.defence + output[:defence_point]
            @defender.speed = @defender.speed + output[:speed_point]

         end
         @pokemon_battle_logs.pokemon_battle_id = @pokemon_battle.id
          @pokemon_battle_logs.turn =  @pokemon_battle.current_turn - 1
          @pokemon_battle_logs.skill_id = nil
          @pokemon_battle_logs.damage = 0
          @pokemon_battle_logs.attacker_id = @attacker.id
          @pokemon_battle_logs.attacker_current_health_point = @attacker.current_health_point
          @pokemon_battle_logs.defender_id = @defender.id
          @pokemon_battle_logs.defender_current_health_point = @defender.current_health_point
          @pokemon_battle_logs.action_type = @commit
         return true
      end
  end

  def save!
    @attacker.save
    @attackerSkill.save if @attackerSkill.present?
    @defender.save
    @pokemon_battle.save
    @pokemon_battle_logs.save
  end

end