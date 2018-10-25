module PokedexesHelper
  def pokedex_params
    params.require(:pokedex).permit(:name, :base_health_point, :base_attack, :base_defence, :base_speed, :element_type, :image_url)
  end
end
