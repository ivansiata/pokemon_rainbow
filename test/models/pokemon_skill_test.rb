require 'test_helper'

class PokemonSkillTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(name: "Name", base_health_point: 1, base_attack: 1, base_defence: 1, base_speed: 1, element_type: "normal")
    @pokedex.save
    @pokemon = Pokemon.new(pokedex_id: @pokedex.id, name: "Name", level: 1, max_health_point: 1, current_health_point: 1, attack: 1, defence: 1, speed: 1, current_experience: 0)
    @pokemon.save
    @skill = Skill.new(name: "Skill 1", power: 1, max_pp: 1, element_type: "normal")
    @skill.save

    @pokedex2 = Pokedex.new(name: "Name2", base_health_point: 1, base_attack: 1, base_defence: 1, base_speed: 1, element_type: "grass")
    @pokedex2.save
    @pokemon2 = Pokemon.new(pokedex_id: @pokedex.id, name: "Name2", level: 1, max_health_point: 1, current_health_point: 1, attack: 1, defence: 1, speed: 1, current_experience: 0)
    @pokemon2.save

    @skill2 = Skill.new(name: "Skill 2", power: 1, max_pp: 1, element_type: "grass")
    @skill2.save

    @skill3 = Skill.new(name: "Skill 3", power: 1, max_pp: 1, element_type: "normal")
    @skill3.save
    @skill4 = Skill.new(name: "Skill 4", power: 1, max_pp: 1, element_type: "normal")
    @skill4.save
    @skill5 = Skill.new(name: "Skill 5", power: 1, max_pp: 1, element_type: "normal")
    @skill5.save
    @skill6 = Skill.new(name: "Skill 6", power: 1, max_pp: 1, element_type: "normal")
    @skill6.save
    @pokemon_skill = PokemonSkill.new(skill_id: @skill.id, pokemon_id: @pokemon.id, current_pp: 1)
  end

  #skill_id
  test "should not save pokemon skill if skill id is not included in pokedex skills" do
    @pokemon_skill.skill_id = @skill2.id
    assert_not @pokemon_skill.save
  end

  test "should save pokemon skill if skill id is included in pokedex skills" do
    assert @pokemon_skill.save
  end

  test "should not save pokemon skill if skill id not unique based on pokemon id" do
    duplicate_pokemon_skill = @pokemon_skill.dup
    @pokemon_skill.save
    assert_not duplicate_pokemon_skill.save
  end

  test "should save pokemon skill if skill unique based on pokemon id" do
    @pokemon_skill.save
    duplicate_pokemon_skill = @pokemon_skill.dup
    duplicate_pokemon_skill.skill_id = @skill2.id
    assert @pokemon_skill.save
  end

  #current pp
  test "should not save pokemon skill if current pp is empty" do
    @pokemon_skill.current_pp = nil
    assert_not @pokemon_skill.save
  end

  test "should save pokemon skill if current pp is not empty" do
    assert @pokemon_skill.save
  end

  test "should not save pokemon if current pp is not integer" do
    @pokemon_skill.current_pp = "string"
    assert_not @pokemon_skill.save
  end

  test "should save pokemon skill if current pp is integer" do
    assert @pokemon_skill.save
  end

  #skill count
  test "should not save pokemon skill if pokemon's skill count is 4" do
    @pokemon_skill.save

    @pokemon_skill3 = PokemonSkill.new(skill_id: @skill3.id, pokemon_id: @pokemon.id, current_pp: 1)
    @pokemon_skill4 = PokemonSkill.new(skill_id: @skill4.id, pokemon_id: @pokemon.id, current_pp: 1)
    @pokemon_skill5 = PokemonSkill.new(skill_id: @skill5.id, pokemon_id: @pokemon.id, current_pp: 1)

    @pokemon_skill3.save
    @pokemon_skill4.save
    @pokemon_skill5.save

    @pokemon_skill6 = PokemonSkill.new(skill_id: @skill6.id, pokemon_id: @pokemon.id, current_pp: 1)
    assert_not @pokemon_skill6.save
  end

  test "should save pokemon skill if pokemon's skill less than 4" do
    assert @pokemon_skill.save
  end

  test "should not save pokemon skill if current pp is greater than max pp" do
    @pokemon_skill.current_pp = @pokemon_skill.skill.max_pp + 1
    assert_not @pokemon_skill.save
  end

  test "should save pokemon skill if current pp is less or equal with max pp" do
    @pokemon_skill.current_pp = @pokemon_skill.skill.max_pp
    assert @pokemon_skill.save
  end

end
