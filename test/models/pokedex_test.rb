require 'test_helper'

class PokedexTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(name: "Name", base_health_point: 1, base_attack: 1, base_defence: 1, base_speed: 1, element_type: "normal")
  end

  test "should not save pokedex if name is empty" do
    @pokedex.name = nil
    assert_not @pokedex.valid?
  end

  test "should save pokedex if name is not empty" do
    assert @pokedex.valid?
  end

  test "should not save pokedex if name greater than 45 character" do
    @pokedex.name = "a" * 46
    assert_not @pokedex.valid?
  end

  test "should save pokedex if name less or equal with 45 character" do
    @pokedex.name = "a" * 45
    assert @pokedex.valid?
  end

  test "should not save pokedex if name not unique" do
    duplicate_pokedex = @pokedex.dup
    @pokedex.save
    assert_not duplicate_pokedex.valid?
  end

  test "should save pokedex if name unique" do
    @pokedex.save
    new_pokedex = @pokedex.dup
    new_pokedex.name = "Name1"
    assert new_pokedex.valid?
  end



end
