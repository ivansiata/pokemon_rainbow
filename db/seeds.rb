puts 'Seeding Skills...'
skill_csv = CSV.open('list_skill.csv', headers: true, header_converters: :symbol)
errors = []
skill_csv.each_with_index do |row, index|
  skill = Skill.new(
    name: row[:name],
    power: row[:power],
    max_pp: row[:max_pp],
    element_type: row[:element_type].to_sym,
    )
  if skill.valid?
    skill.save
  else
    errors << "Skill Import : line #{index + 1}: " + skill.errors.full_messages.join(", ")
  end
end

puts 'Seeding Pokedexes, Pokemons, Random Pokemon Skills...'
pokedex_csv = CSV.open('list_pokedex.csv', headers: true, header_converters: :symbol)
pokedex_csv.each_with_index do |row, index|
  pokedex = Pokedex.new(
    name: row[:name],
    base_health_point: row[:base_health_point],
    base_attack: row[:base_attack],
    base_defence: row[:base_defence],
    base_speed: row[:base_speed],
    element_type: row[:element_type].to_sym,
    image_url: row[:image_url]
    )
  if pokedex.valid?
    pokedex.save
    pokemon = Pokemon.new(pokedex_id: pokedex.id, name: pokedex.name)
    pokemon.level = 1
    pokemon.current_experience = 0
    pokemon.current_health_point = pokemon.pokedex.base_health_point
    pokemon.max_health_point = pokemon.pokedex.base_health_point
    pokemon.attack = pokemon.pokedex.base_defence
    pokemon.defence = pokemon.pokedex.base_attack
    pokemon.speed = pokemon.pokedex.base_speed

    pokemon.save

    skill_list = Skill.where(element_type: pokemon.pokedex.element_type).ids
    pokemon_skills_list = skill_list.sample(rand(2..4))
    pokemon_skills_list.each do |pokemon_skill|
    pokemonSkill = pokemon.pokemon_skills.new(skill_id: pokemon_skill, pokemon_id: pokemon.id)
    pokemonSkill.current_pp = pokemonSkill.skill.max_pp

    pokemonSkill.save

    end
  else
    errors << " Pokedex Import : line #{index + 1}: " + pokedex.errors.full_messages.join(", ")
  end
end
puts errors