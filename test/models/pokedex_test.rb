require 'test_helper'

class PokedexTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(name: "Name", base_health_point: 1, base_attack: 1, base_defence: 1, base_speed: 1, element_type: "normal")
  end

  #name
  test "should not save pokedex if name is empty" do
    @pokedex.name = nil
    assert_not @pokedex.save
  end

  test "should save pokedex if name is not empty" do
    assert @pokedex.save
  end

  test "should not save pokedex if name greater than 45 character" do
    @pokedex.name = "a" * 46
    assert_not @pokedex.save
  end

  test "should save pokedex if name less or equal with 45 character" do
    @pokedex.name = "a" * 45
    assert @pokedex.save
  end

  test "should not save pokedex if name not unique" do
    duplicate_pokedex = @pokedex.dup
    @pokedex.save
    assert_not duplicate_pokedex.save
  end

  test "should save pokedex if name unique" do
    @pokedex.save
    new_pokedex = @pokedex.dup
    new_pokedex.name = "Name1"
    assert new_pokedex.save
  end

  #base health point
  test "should not save pokedex if base health point is empty" do
    @pokedex.base_health_point = nil
    assert_not @pokedex.save
  end

  test "should save pokedex if base health point is not empty" do
    assert @pokedex.save
  end

  test "should not save pokedex if base health point less than 1" do
    @pokedex.base_health_point = 0
    assert_not @pokedex.save
  end

  test "should save pokedex if base health point is greater or equal to 1" do
    @pokedex.base_health_point = 1
    assert @pokedex.save
  end

  test "should not save pokedex if base health point is not integer" do
    @pokedex.base_health_point = "string"
    assert_not @pokedex.save
  end

  test "should save pokedex if base health point is integer" do
    @pokedex.base_health_point = 3
    assert @pokedex.save
  end

  #base attack
  test "should not save pokedex if base attack is empty" do
    @pokedex.base_attack = nil
    assert_not @pokedex.save
  end

  test "should save pokedex if base attack is not empty" do
    assert @pokedex.save
  end

  test "should not save pokedex if base attack less than 1" do
    @pokedex.base_attack = 0
    assert_not @pokedex.save
  end

  test "should save pokedex if base attack is greater or equal to 1" do
    @pokedex.base_attack = 1
    assert @pokedex.save
  end

  test "should not save pokedex if base attack is not integer" do
    @pokedex.base_attack = "string"
    assert_not @pokedex.save
  end

  test "should save pokedex if base attack is integer" do
    @pokedex.base_attack = 3
    assert @pokedex.save
  end

  #base defence
  test "should not save pokedex if base defence is empty" do
    @pokedex.base_defence = nil
    assert_not @pokedex.save
  end

  test "should save pokedex if base defence is not empty" do
    assert @pokedex.save
  end

  test "should not save pokedex if base defence less than 1" do
    @pokedex.base_defence = 0
    assert_not @pokedex.save
  end

  test "should save pokedex if base defence is greater or equal to 1" do
    @pokedex.base_defence = 1
    assert @pokedex.save
  end

  test "should not save pokedex if base defence is not integer" do
    @pokedex.base_defence = "string"
    assert_not @pokedex.save
  end

  test "should save pokedex if base defence is integer" do
    @pokedex.base_defence = 3
    assert @pokedex.save
  end

  #base speed
  test "should not save pokedex if base speed is empty" do
    @pokedex.base_speed = nil
    assert_not @pokedex.save
  end

  test "should save pokedex if base speed is not empty" do
    assert @pokedex.save
  end

  test "should not save pokedex if base speed less than 1" do
    @pokedex.base_speed = 0
    assert_not @pokedex.save
  end

  test "should save pokedex if base speed is greater or equal to 1" do
    @pokedex.base_speed = 1
    assert @pokedex.save
  end

  test "should not save pokedex if base speed is not integer" do
    @pokedex.base_speed = "string"
    assert_not @pokedex.save
  end

  test "should save pokedex if base speed is integer" do
    @pokedex.base_speed = 3
    assert @pokedex.save
  end

  #enumerize
  test "should not save pokedex if element not included in enumerize" do
    @pokedex.element_type = "sdasd"
    assert_not @pokedex.save
  end

  test "should save pokedex if element included in enumerize" do
    assert @pokedex.save
  end

end
