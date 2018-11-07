module Statistic
  def self.most_win(element)


    sql = "SELECT p.name, COUNT(pokemon_winner_id) as pokemon_winner_count
            FROM pokemon_battles pb JOIN pokemons p ON p.id = pb.pokemon_winner_id JOIN pokedexes ps ON ps.id = p.pokedex_id
            WHERE "
    if element != 'global'
      sql += "ps.element_type = '#{element}' AND "
    end
    sql += "pokemon_winner_id IS NOT NULL
      GROUP BY p.name ORDER BY pokemon_winner_count DESC LIMIT 5"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.most_lose(element)
    sql = "SELECT p.name, COUNT(pokemon_loser_id) as pokemon_loser_count
            FROM pokemon_battles pb JOIN pokemons p ON p.id = pb.pokemon_loser_id JOIN pokedexes ps ON ps.id = p.pokedex_id
            WHERE "
    if element != 'global'
      sql += "ps.element_type = '#{element}' AND "
    end
    sql += "pokemon_loser_id IS NOT NULL
            GROUP BY p.name ORDER BY pokemon_loser_count DESC LIMIT 5
          "
    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.most_skill_used(element)
    sql = "SELECT s.name, COUNT(*) as count_skill_used FROM pokemon_battle_logs pb
    JOIN skills s ON s.id = pb.skill_id "
    if element != 'global'
      sql += "WHERE s.element_type = '#{element}' "
    end
    sql += "GROUP BY s.name ORDER BY count_skill_used DESC LIMIT 5"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.most_picked_pokemon(element)
    sql = "SELECT p.name, COUNT(*) as pokemon_count FROM pokemon_battles pb
    JOIN pokemons p ON pb.pokemon1_id = p.id OR pb.pokemon2_id = p.id JOIN pokedexes ps ON ps.id = p.id "
    if element != 'global'
      sql += "WHERE ps.element_type = '#{element}' "
    end
    sql += "GROUP BY p.name ORDER BY pokemon_count DESC LIMIT 5"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.most_surrender_pokemon(element)
    sql = "SELECT p.name, COUNT(*) pokemon_surrender_count FROM pokemon_battle_logs pb
          JOIN pokemons p ON p.id = pb.attacker_id JOIN pokedexes ps ON ps.id = p.pokedex_id WHERE "
    if element != 'global'
      sql += "ps.element_type = '#{element}' AND "
    end
    sql += "pb.action_type = 'Surrender' GROUP BY p.name ORDER BY pokemon_surrender_count DESC LIMIT 5"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end



end