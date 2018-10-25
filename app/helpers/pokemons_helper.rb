module PokemonsHelper
  def options_for_pokedex_id
    Pokedex.all.map do |p|
      [p.name, p.id]
    end
  end
end
