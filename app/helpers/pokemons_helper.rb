module PokemonsHelper
  def pokemon_params
    params.require(:pokemon).permit(:name, :pokedex_id)
  end

  def pokemon_edit_params
    params.require(:pokemon).permit(:max_health_point, :current_health_point, :attack, :defence, :speed)
  end

  def pokemon_skill_params
    params.require(:pokemon_skill).permit(:skill_id)
  end

  def options_for_pokedex_id
    Pokedex.all.map do |p|
      [p.name, p.id]
    end
  end

  def options_for_skill
    Skill.all.map do |p|
      [p.name, p.id]
    end
  end
end
