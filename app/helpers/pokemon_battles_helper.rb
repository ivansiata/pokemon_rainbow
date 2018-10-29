module PokemonBattlesHelper
  def options_for_pokemon_id
    Pokemon.where("current_health_point > ?", 0).map do |p|
      [p.name, p.id]
    end
  end

  def pokemon_battle_params
    params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
  end
end
