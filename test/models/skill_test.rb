require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  def setup
    @skill = Skill.new(name: "Name", power: 1, max_pp: 1, element_type: "normal")
  end

  #name
  test "should not save skill if name is empty" do
    @skill.name = nil
    assert_not @skill.save
  end

  test "should save skill if name is not empty" do
    assert @skill.save
  end

  test "should not save skill if name greater than 45 character" do
    @skill.name = "a" * 46
    assert_not @skill.save
  end

  test "should save skill if name less or equal with 45 character" do
    @skill.name = "a" * 45
    assert @skill.save
  end

  test "should not save skill if name not unique" do
    duplicate_skill = @skill.dup
    @skill.save
    assert_not duplicate_skill.save
  end

  test "should save skill if name unique" do
    @skill.save
    new_skill = @skill.dup
    new_skill.name = "Name1"
    assert new_skill.save
  end

  #power
  test "should not save skill if power is empty" do
    @skill.power = nil
    assert_not @skill.save
  end

  test "should save skill if power is not empty" do
    assert @skill.save
  end

  test "should not save skill if power less than 1" do
    @skill.power = 0
    assert_not @skill.save
  end

  test "should save skill if power is greater or equal to 1" do
    @skill.power = 1
    assert @skill.save
  end

  test "should not save skill if power is not integer" do
    @skill.power = "string"
    assert_not @skill.save
  end

  test "should save skill if power is integer" do
    @skill.power = 3
    assert @skill.save
  end

  #max_pp
  test "should not save skill if max pp is empty" do
    @skill.max_pp = nil
    assert_not @skill.save
  end

  test "should save skill if max pp is not empty" do
    assert @skill.save
  end

  test "should not save skill if max pp less than 1" do
    @skill.max_pp = 0
    assert_not @skill.save
  end

  test "should save skill if max pp is greater or equal to 1" do
    @skill.max_pp = 1
    assert @skill.save
  end

  test "should not save skill if max pp is not integer" do
    @skill.max_pp = "string"
    assert_not @skill.save
  end

  test "should save skill if max pp is integer" do
    @skill.max_pp = 3
    assert @skill.save
  end

  #enumerize
  test "should not save skill if element not included in enumerize" do
    @skill.element_type = "sdasd"
    assert_not @skill.save
  end

  test "should save skill if element included in enumerize" do
    assert @skill.save
  end
end
