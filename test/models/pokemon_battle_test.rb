require 'test_helper'

class PokemonBattleTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(name: "Name", base_health_point: 1, base_attack: 1, base_defence: 1, base_speed: 1, element_type: "normal")
    @pokedex.save
    @pokemon = Pokemon.new(pokedex_id: @pokedex.id, name: "Name", level: 1, max_health_point: 1, current_health_point: 1, attack: 1, defence: 1, speed: 1, current_experience: 0)
    @pokemon.save
    @pokemon2 = Pokemon.new(pokedex_id: @pokedex.id, name: "Name 2", level: 1, max_health_point: 1, current_health_point: 1, attack: 1, defence: 1, speed: 1, current_experience: 0)
    @pokemon2.save
    @skill = Skill.new(name: "Skill 1", power: 1, max_pp: 1, element_type: "normal")
    @skill.save

    @pokemon_battle = PokemonBattle.new(pokemon1_id: @pokemon.id, pokemon2_id: @pokemon2.id, current_turn: 1, state: "ongoing", pokemon_winner_id: nil, pokemon_loser_id: nil, experience_gain: 0, pokemon1_max_health_point: @pokemon.max_health_point, pokemon2_max_health_point: @pokemon2.max_health_point)
  end

  test "should not save pokemon battle if pokemon 1 same with pokemon 2" do
    @pokemon_battle.pokemon1_id = @pokemon_battle.pokemon2_id
    assert_not @pokemon_battle.save
  end

  test "should save pokemon battle if pokemon 1 different with pokemon 2" do
    assert @pokemon_battle.save
  end

  test "should not save pokemon battle if pokemon 1 or pokemon 2 current_hp is zero" do
    @pokemon.current_health_point = 0
    @pokemon.save
    assert_not @pokemon_battle.save
  end

  test "should save pokemon battle if pokemon 1 or pokemon 2 current_hp greater than zero" do
    assert @pokemon_battle.save
  end

  test "should not save pokemon battle if pokemon 1 or pokemon 2 inside ongoing battle" do
    @pokemon_battle.save
    @pokemon3 = Pokemon.new(pokedex_id: @pokedex.id, name: "Name 3", level: 1, max_health_point: 1, current_health_point: 1, attack: 1, defence: 1, speed: 1, current_experience: 0)
    @pokemon3.save
    new_battle = PokemonBattle.new(pokemon1_id: @pokemon3.id, pokemon2_id: @pokemon2.id, current_turn: 1, state: "ongoing", pokemon_winner_id: nil, pokemon_loser_id: nil, experience_gain: 0, pokemon1_max_health_point: @pokemon.max_health_point, pokemon2_max_health_point: @pokemon2.max_health_point)
    assert_not new_battle.save
  end

  test "should save pokemon battle if pokemon 1 or pokemon 2 not in ongoing battle" do
    duplicate_pokemon_battle = @pokemon_battle.dup
    @pokemon_battle.state = "finished"
    @pokemon_battle.save
    assert duplicate_pokemon_battle.save
  end

  #enumerize
  test "should not save pokedex if state not included in enumerize" do
    @pokemon_battle.state = "sdasd"
    assert_not @pokemon_battle.save
  end

  test "should save pokedex if state included in enumerize" do
    assert @pokemon_battle.save
  end

end
