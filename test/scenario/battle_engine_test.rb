require 'test_helper'

class BattleEngineTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(name: "Name", base_health_point: 1, base_attack: 1, base_defence: 1, base_speed: 1, element_type: "normal")
    @pokedex.save

    @pokemon1 = Pokemon.new(pokedex_id: @pokedex.id, name: "Name", level: 1, max_health_point: 1, current_health_point: 1, attack: 1, defence: 1, speed: 1, current_experience: 0)
    @pokemon1.save
    @pokemon2 = Pokemon.new(pokedex_id: @pokedex.id, name: "Name 2", level: 1, max_health_point: 1, current_health_point: 1, attack: 1, defence: 1, speed: 1, current_experience: 0)
    @pokemon2.save

    @skill = Skill.new(name: "Skill 1", power: 100, max_pp: 1, element_type: "normal")
    @skill.save
    @skill2 = Skill.new(name: "Skill 2", power: 1, max_pp: 1, element_type: "grass")
    @skill2.save

    @pokemon1_skill = PokemonSkill.new(skill_id: @skill.id, pokemon_id: @pokemon1.id, current_pp: 1)
    @pokemon1_skill.save

    @pokemon2_skill = PokemonSkill.new(skill_id: @skill2.id, pokemon_id: @pokemon2.id, current_pp: 1)
    @pokemon2_skill.save

    @pokemon_battle = PokemonBattle.new(pokemon1_id: @pokemon1.id, pokemon2_id: @pokemon2.id, current_turn: 1, state: "ongoing", pokemon_winner_id: nil, pokemon_loser_id: nil, experience_gain: 0, pokemon1_max_health_point: @pokemon1.max_health_point, pokemon2_max_health_point: @pokemon2.max_health_point, battle_type: 3)
    @pokemon_battle.save

    @pokemon1_battle = @pokemon_battle.pokemon1
    @pokemon2_battle = @pokemon_battle.pokemon2

    @pokemonId = @pokemon_battle.pokemon1.id
    @commit = "Attack"
    @selectedSkill = @skill.id

  end

  test "attack should not work if current turn not equal with pokemon id" do
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemon_battle.pokemon2.id, @commit, @selectedSkill)
    assert_not battleEngine.valid_next_turn?
  end

  test "should work if current turn equal with pokemon id" do
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    assert battleEngine.valid_next_turn?
  end

  test "should not work if attack not included in pokemon skill" do
    @selectedSkill = @skill2.id

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    assert_not battleEngine.next_turn!
  end

  test "should work if attack include in pokemon skill" do
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    assert battleEngine.next_turn!
  end

  test "should not work if current pp is empty" do
    @pokemon1_skill.current_pp = 0
    @pokemon1_skill.save
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    assert_not battleEngine.next_turn!
  end

  test "should work if current pp is not empty" do
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    assert battleEngine.next_turn!
  end

  test "state should be finished if the battle finish" do
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    battleEngine.next_turn!
    battleEngine.save!

    assert_equal "finished", @pokemon_battle.state
  end

  test "turn should add 1 after action done" do
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    turn = @pokemon_battle.current_turn + 1
    battleEngine.next_turn!
    battleEngine.save!
    assert_equal turn, @pokemon_battle.current_turn
  end

  test "attacker PP should be decreased by 1 after attack" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    attackPP = @pokemon_battle.pokemon1.pokemon_skills.find_by(skill_id: @selectedSkill).current_pp - 1
    battleEngine.next_turn!
    battleEngine.save!

    assert_equal attackPP, @pokemon_battle.pokemon1.pokemon_skills.find_by(skill_id: @selectedSkill).current_pp

  end

  test "defender HP should be decreased if attack" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    defenderHP = @pokemon_battle.pokemon2.current_health_point
    battleEngine.next_turn!
    battleEngine.save!

    assert_not_equal defenderHP, @pokemon_battle.pokemon2.current_health_point

  end

  test "winner should be chosen if the battle ends" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    battleEngine.next_turn!
    battleEngine.save!

    assert_equal @pokemon1_battle.id, @pokemon_battle.pokemon_winner_id

  end

  test "loser should be chosen if the battle ends" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    battleEngine.next_turn!
    battleEngine.save!

    assert_equal @pokemon2_battle.id, @pokemon_battle.pokemon_loser_id

  end

  test "winner experience should be increased after winning the battle" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    pokemonCurrentExperience = @pokemon1_battle.current_experience
    battleEngine.next_turn!
    battleEngine.save!

    assert_equal @pokemon1_battle.current_experience, pokemonCurrentExperience + @pokemon_battle.experience_gain

  end

  test "winner level should be increased a if experience pass the limit" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon1_battle.current_experience = 199
    pokemonCurrentLevel = @pokemon1_battle.level
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon1_battle.level, :>, pokemonCurrentLevel

  end

  test "winner max health point should be increased if level up" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon1_battle.current_experience = 199
    pokemonCurrentMaxHealthPoint = @pokemon1_battle.max_health_point
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon1_battle.max_health_point, :>, pokemonCurrentMaxHealthPoint

  end

  test "winner attack should be increased if level up" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon1_battle.current_experience = 199
    pokemonCurrentAttack = @pokemon1_battle.attack
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon1_battle.attack, :>, pokemonCurrentAttack

  end

  test "winner defence should be increased if level up" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon1_battle.current_experience = 199
    pokemonCurrentDefence = @pokemon1_battle.defence
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon1_battle.attack, :>, pokemonCurrentDefence

  end

  test "winner speed should be increased if level up" do

    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon1_battle.current_experience = 199
    pokemonCurrentSpeed = @pokemon1_battle.speed
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon1_battle.attack, :>, pokemonCurrentSpeed

  end

  test "surrender should not work if current turn not equal with pokemon id" do
    @commit = "Surrender"
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemon_battle.pokemon2.id, @commit, @selectedSkill)
    assert_not battleEngine.valid_next_turn?
  end

  test "state should be finished if attacker surrender" do
    @commit = "Surrender"
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    battleEngine.next_turn!
    battleEngine.save!

    assert_equal "finished", @pokemon_battle.state
  end

  test "turn should add 1 after surrender" do
    @commit = "Surrender"
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    turn = @pokemon_battle.current_turn + 1
    battleEngine.next_turn!
    battleEngine.save!
    assert_equal turn, @pokemon_battle.current_turn
  end

  test "defender experience should be increased after attacker surrender" do
    @commit = "Surrender"
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    pokemonCurrentExperience = @pokemon2_battle.current_experience
    battleEngine.next_turn!
    battleEngine.save!

    assert_equal @pokemon2_battle.current_experience, pokemonCurrentExperience + @pokemon_battle.experience_gain

  end

  test "defender level should be increased if attacker surrender and defender level up" do
    @commit = "Surrender"
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon2_battle.current_experience = 199
    pokemonCurrentLevel = @pokemon2_battle.level
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon2_battle.level, :>, pokemonCurrentLevel

  end

  test "defender max health point should be increased if attacker surrender and defender level up" do
    @commit = "Surrender"
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon2_battle.current_experience = 199
    pokemonCurrentMaxHealthPoint = @pokemon2_battle.max_health_point
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon2_battle.max_health_point, :>, pokemonCurrentMaxHealthPoint

  end

  test "defender attack should be increased if attacker surrender and defender level up" do
    @commit = "Surrender"
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon2_battle.current_experience = 199
    pokemonCurrentAttack = @pokemon2_battle.attack
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon2_battle.attack, :>, pokemonCurrentAttack

  end

  test "defender defence should be increased if attacker surrender and defender level up" do
    @commit = "Surrender"
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon2_battle.current_experience = 199
    pokemonCurrentDefence = @pokemon2_battle.defence
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon2_battle.attack, :>, pokemonCurrentDefence

  end

  test "defender speed should be increased if attacker surrender and defender level up" do
    @commit = "Surrender"
    battleEngine = BattleEngine.new(@pokemon_battle, @pokemonId, @commit, @selectedSkill)
    @pokemon2_battle.current_experience = 199
    pokemonCurrentSpeed = @pokemon2_battle.speed
    battleEngine.next_turn!
    battleEngine.save!

    assert_operator @pokemon2_battle.attack, :>, pokemonCurrentSpeed

  end

end