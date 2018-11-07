require 'test_helper'

class AiBattleEngineTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(name: "Name", base_health_point: 1, base_attack: 1, base_defence: 1, base_speed: 1, element_type: "normal")
    @pokedex.save

    @pokemon1 = Pokemon.new(pokedex_id: @pokedex.id, name: "Name", level: 1, max_health_point: 100, current_health_point: 100, attack: 1, defence: 1, speed: 1, current_experience: 0)
    @pokemon1.save
    @pokemon2 = Pokemon.new(pokedex_id: @pokedex.id, name: "Name 2", level: 1, max_health_point: 100, current_health_point: 100, attack: 1, defence: 1, speed: 1, current_experience: 0)
    @pokemon2.save

    @skill = Skill.new(name: "Skill 1", power: 10, max_pp: 1, element_type: "normal")
    @skill.save
    @skill2 = Skill.new(name: "Skill 2", power: 1, max_pp: 1, element_type: "normal")
    @skill2.save

    @pokemon1_skill = PokemonSkill.new(skill_id: @skill.id, pokemon_id: @pokemon1.id, current_pp: 1)
    @pokemon1_skill.save

    @pokemon2_skill = PokemonSkill.new(skill_id: @skill2.id, pokemon_id: @pokemon2.id, current_pp: 1)
    @pokemon2_skill.save

    @pokemon_battle = PokemonBattle.new(pokemon1_id: @pokemon1.id, pokemon2_id: @pokemon2.id, current_turn: 1, state: "ongoing", pokemon_winner_id: nil, pokemon_loser_id: nil, experience_gain: 0, pokemon1_max_health_point: @pokemon1.max_health_point, pokemon2_max_health_point: @pokemon2.max_health_point, battle_type: "vs_ai")
    @pokemon_battle.save

    @pokemon1_battle = @pokemon_battle.pokemon1
    @pokemon2_battle = @pokemon_battle.pokemon2

    @pokemon_battle_logs = PokemonBattleLog.new

    @pokemonId = @pokemon_battle.pokemon1.id
    @commit = "Attack"
    @selectedSkill = @skill.id
  end

  test "check if player automaticaly attacked after attacking" do
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    battleEngine.next_turn!
    battleEngine.save!

    pokemonCurrentHealth = @pokemon_battle.pokemon1.current_health_point

    aiTurn = AiBattleEngine.new(@pokemon_battle)
    aiTurn.ai_turn!

    assert_operator pokemonCurrentHealth, :>, @pokemon_battle.pokemon1.current_health_point
  end

  test "check if turn add by 2 after player attack" do
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    battleEngine.next_turn!
    battleEngine.save!

    currenTurn = 1

    aiTurn = AiBattleEngine.new(@pokemon_battle)
    aiTurn.ai_turn!

    assert_equal currenTurn + 2, @pokemon_battle.current_turn
  end

  test "check if AI surrender if doesn't have any skill PP" do
    # check di pokemon battle log terakhir harusnya action nya
    @pokemon2_battle.pokemon_skills.each do |pokemon_skill|
      pokemon_skill.current_pp = 0
      pokemon_skill.save
    end

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, nil)
    battleEngine.next_turn!
    battleEngine.save!

    aiTurn = AiBattleEngine.new(@pokemon_battle)
    aiTurn.ai_turn!
    assert_equal "Surrender", @pokemon_battle.pokemon_battle_logs.last.action_type
  end

  test "check if state finished after auto battle" do
    @pokemon_battle.battle_type = "auto"
    autoBattle = AiBattleEngine.new(@pokemon_battle)
    autoBattle.auto_battle!

    assert_equal @pokemon_battle.state, "finished"
  end

  test "check if pokemon_winner_id and pokemon_loser_id chosen after auto battle" do
    @pokemon_battle.battle_type = "auto"
    autoBattle = AiBattleEngine.new(@pokemon_battle)
    autoBattle.auto_battle!

    assert @pokemon_battle.pokemon_winner_id.present?
    assert @pokemon_battle.pokemon_loser_id.present?
  end



end