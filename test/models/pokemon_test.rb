require 'test_helper'

class PokemonTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(name: "Name", base_health_point: 1, base_attack: 1, base_defence: 1, base_speed: 1, element_type: "normal")
    @pokedex.save
    @pokedex2 = Pokedex.new(name: "Name2", base_health_point: 1, base_attack: 1, base_defence: 1, base_speed: 1, element_type: "normal")
    @pokedex2.save
    @pokemon = Pokemon.new(pokedex_id: @pokedex.id, name: "Name", level: 1, max_health_point: 1, current_health_point: 1, attack: 1, defence: 1, speed: 1, current_experience: 0)
  end

  #pokemon_id
  test "should not save pokemon if pokedex_id not included in pokedex" do
    @pokemon.pokedex_id = -1
    assert_not @pokemon.save
  end

  test "should save pokemon if pokedex_id included in pokedex" do
    assert @pokemon.save
  end

  #name
  test "should not save pokemon if name is empty" do
    @pokemon.name = nil
    assert_not @pokemon.save
  end

  test "should save pokemon if name is not empty" do
    assert @pokemon.save
  end

  test "should not save pokemon if name greater than 45 character" do
    @pokemon.name = "a" * 46
    assert_not @pokemon.save
  end

  test "should save pokemon if name less or equal with 45 character" do
    @pokemon.name = "a" * 45
    assert @pokemon.save
  end

  test "should not save pokemon if name not unique based on pokedex" do
    duplicate_pokemon = @pokemon.dup
    @pokemon.save
    assert_not duplicate_pokemon.save
  end

  test "should save pokemon if name unique base on pokedex" do
    @pokemon.save
    new_pokemon = @pokemon.dup
    new_pokemon.pokedex_id = @pokedex2.id
    assert new_pokemon.save
  end

  #max health point
  test "should not save pokemon if max health point is empty" do
    @pokemon.max_health_point = nil
    assert_not @pokemon.save
  end

  test "should save pokemon if max health point is not empty" do
    assert @pokemon.save
  end

  test "should not save pokemon if max health point less than 1" do
    @pokemon.max_health_point = 0
    assert_not @pokemon.save
  end

  test "should save pokemon if max health point is greater or equal to 1" do
    @pokemon.max_health_point = 1
    assert @pokemon.save
  end

  test "should not save pokemon if max health point is not integer" do
    @pokemon.max_health_point = "string"
    assert_not @pokemon.save
  end

  test "should save pokemon if max health point is integer" do
    @pokemon.max_health_point = 3
    assert @pokemon.save
  end

  #current health point
  test "should not save pokemon if current health point is empty" do
    @pokemon.current_health_point = nil
    assert_not @pokemon.save
  end

  test "should save pokemon if current health point is not empty" do
    assert @pokemon.save
  end

  test "should not save pokemon if current health point less than 0" do
    @pokemon.current_health_point = -1
    assert_not @pokemon.save
  end

  test "should save pokemon if current health point is greater or equal to 0" do
    @pokemon.current_health_point = 1
    assert @pokemon.save
  end

  test "should not save pokemon if current health point is not integer" do
    @pokemon.current_health_point = "string"
    assert_not @pokemon.save
  end

  test "should save pokemon if current health point is integer" do
    assert @pokemon.save
  end

  test "should not save pokemon if current health point greater than max_health_point" do
    @pokemon.current_health_point = @pokemon.max_health_point + 1
    assert_not @pokemon.save
  end

  test "should save pokemon if current health point is less than max_health_point" do
    @pokemon.current_health_point = @pokemon.max_health_point
    assert @pokemon.save
  end

  #current expereience
  test "should not save pokemon if current expereience is empty" do
    @pokemon.current_experience = nil
    assert_not @pokemon.save
  end

  test "should save pokemon if current expereience is not empty" do
    assert @pokemon.save
  end

  test "should not save pokemon if current expereience less than 0" do
    @pokemon.current_experience = -1
    assert_not @pokemon.save
  end

  test "should save pokemon if current expereience is greater or equal to 0" do
    @pokemon.current_experience = 1
    assert @pokemon.save
  end

  test "should not save pokemon if current expereience is not integer" do
    @pokemon.current_experience = "string"
    assert_not @pokemon.save
  end

  test "should save pokemon if current expereience is integer" do
    @pokemon.current_experience = 3
    assert @pokemon.save
  end

  #attack
  test "should not save pokemon if attack is empty" do
    @pokemon.attack = nil
    assert_not @pokemon.save
  end

  test "should save pokemon if attack is not empty" do
    assert @pokemon.save
  end

  test "should not save pokemon if attack less than 1" do
    @pokemon.attack = 0
    assert_not @pokemon.save
  end

  test "should save pokemon if attack is greater or equal to 1" do
    @pokemon.attack = 1
    assert @pokemon.save
  end

  test "should not save pokemon if attack is not integer" do
    @pokemon.attack = "string"
    assert_not @pokemon.save
  end

  test "should save pokemon if attack is integer" do
    @pokemon.attack = 3
    assert @pokemon.save
  end

  #defence
  test "should not save pokemon if defence is empty" do
    @pokemon.defence = nil
    assert_not @pokemon.save
  end

  test "should save pokemon if defence is not empty" do
    assert @pokemon.save
  end

  test "should not save pokemon if defence less than 1" do
    @pokemon.defence = 0
    assert_not @pokemon.save
  end

  test "should save pokemon if defence is greater or equal to 1" do
    @pokemon.defence = 1
    assert @pokemon.save
  end

  test "should not save pokemon if defence is not integer" do
    @pokemon.defence = "string"
    assert_not @pokemon.save
  end

  test "should save pokemon if defence is integer" do
    @pokemon.defence = 3
    assert @pokemon.save
  end

  #speed
  test "should not save pokemon if speed is empty" do
    @pokemon.speed = nil
    assert_not @pokemon.save
  end

  test "should save pokemon if speed is not empty" do
    assert @pokemon.save
  end

  test "should not save pokemon if speed less than 1" do
    @pokemon.speed = 0
    assert_not @pokemon.save
  end

  test "should save pokemon if speed is greater or equal to 1" do
    @pokemon.speed = 1
    assert @pokemon.save
  end

  test "should not save pokemon if speed is not integer" do
    @pokemon.speed = "string"
    assert_not @pokemon.save
  end

  test "should save pokemon if speed is integer" do
    @pokemon.speed = 3
    assert @pokemon.save
  end

  #level
  test "should not save pokemon if level is empty" do
    @pokemon.level = nil
    assert_not @pokemon.save
  end

  test "should save pokemon if level is not empty" do
    assert @pokemon.save
  end

  test "should not save pokemon if level less than 1" do
    @pokemon.level = 0
    assert_not @pokemon.save
  end

  test "should save pokemon if level is greater or equal to 1" do
    @pokemon.level = 1
    assert @pokemon.save
  end

  test "should not save pokemon if level is not integer" do
    @pokemon.level = "string"
    assert_not @pokemon.save
  end

  test "should save pokemon if level is integer" do
    @pokemon.level = 3
    assert @pokemon.save
  end

end
