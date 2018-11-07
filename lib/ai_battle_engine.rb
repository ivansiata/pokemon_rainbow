class AiBattleEngine

  def initialize(pokemon_battle)
    @pokemon_battle = pokemon_battle
    @commit = "Attack"
  end

  def auto_battle!
    while @pokemon_battle.pokemon_winner_id.nil?

      if @pokemon_battle.current_turn % 2 != 0
        aiSkills = @pokemon_battle.pokemon1.pokemon_skills.where("current_pp > ?", 0).map do |pokemon_skill|
          pokemon_skill.skill_id
        end
      else
        aiSkills = @pokemon_battle.pokemon2.pokemon_skills.where("current_pp > ?", 0).map do |pokemon_skill|
          pokemon_skill.skill_id
        end
      end
      if aiSkills.present?
        @aiSelectedSkill = aiSkills.sample
      else
        @commit = "Surrender"
        @aiSelectedSkill = nil
      end

      battleEngine = BattleEngine.new(@pokemon_battle, nil, @commit, @aiSelectedSkill)
      battleEngine.next_turn!
      battleEngine.save!
    end
  end

  def ai_turn!
    aiSkills = @pokemon_battle.pokemon2.pokemon_skills.where("current_pp > ?", 0).map do |pokemon_skill|
      pokemon_skill.skill_id
    end

    if aiSkills.present?
      @aiSelectedSkill = aiSkills.sample
    else
      @commit = "Surrender"
      @commit_change = "Surrender"
      @aiSelectedSkill = nil
    end

    battleEngine = BattleEngine.new(@pokemon_battle, nil, @commit, @aiSelectedSkill)
    battleEngine.next_turn!
    battleEngine.save!
  end

end