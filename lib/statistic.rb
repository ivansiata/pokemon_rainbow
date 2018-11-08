module Statistic

  def self.top_5_pokemon_winner(element)
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


  def self.top_5_pokemon_loser(element)
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


  def self.top_5_skill_used(element)
    sql = "SELECT s.name, COUNT(*) as count_skill_used FROM pokemon_battle_logs pb
    JOIN skills s ON s.id = pb.skill_id "
    if element != 'global'
      sql += "WHERE s.element_type = '#{element}' "
    end
    sql += "GROUP BY s.name ORDER BY count_skill_used DESC LIMIT 5"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end


  def self.top_5_picked_pokemon_in_battles(element)
    sql = "SELECT p.name, COUNT(*) as pokemon_count FROM pokemon_battles pb
    JOIN pokemons p ON pb.pokemon1_id = p.id OR pb.pokemon2_id = p.id JOIN pokedexes ps ON ps.id = p.id "
    if element != 'global'
      sql += "WHERE ps.element_type = '#{element}' "
    end
    sql += "GROUP BY p.name ORDER BY pokemon_count DESC LIMIT 5"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.top_5_surrender_pokemon_in_battles(element)
    sql = "SELECT p.name, COUNT(*) pokemon_surrender_count FROM pokemon_battle_logs pb
          JOIN pokemons p ON p.id = pb.attacker_id JOIN pokedexes ps ON ps.id = p.pokedex_id WHERE "
    if element != 'global'
      sql += "ps.element_type = '#{element}' AND "
    end
    sql += "pb.action_type = 'Surrender' GROUP BY p.name ORDER BY pokemon_surrender_count DESC LIMIT 5"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.win_lose_ratio_by_pokemon(pokemon)
    sql = "SELECT
          sum(case when pokemon_winner_id = #{pokemon} then 1 else 0 end) as win_count,
          sum(case when pokemon_loser_id = #{pokemon} then 1 else 0 end) as lose_count
          FROM pokemon_battles pb JOIN pokemons p ON pb.pokemon_winner_id = p.id OR pb.pokemon_loser_id = p.id
          WHERE p.id = #{pokemon}
          GROUP BY p.id"

    result = ActiveRecord::Base.connection.execute(sql)
    a = result.values

    if a.present?
      resultHash = {"win" => a[0][0], "lose" => a[0][1]}
    end
  end

  def self.pokemon_percentage_by_pokemon_trainer(pokemon_trainer)
    sql = "SELECT ps.element_type,  COUNT(*) *100 / (SELECT COUNT(*) FROM pokemon_trainers WHERE trainer_id = #{pokemon_trainer}) as percentage
    FROM pokemon_trainers pt JOIN pokemons p ON p.id = pt.pokemon_id JOIN pokedexes ps ON ps.id = p.pokedex_id
    WHERE trainer_id = #{pokemon_trainer} GROUP BY ps.element_type"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.most_chosen_pokemon_to_battle_by_trainer(pokemon_trainer)
    sql = "SELECT p.name, battle_count FROM pokemon_trainers ps JOIN pokemons p ON p.id = ps.pokemon_id
    WHERE ps.trainer_id =  #{pokemon_trainer}
    ORDER BY battle_count DESC LIMIT 5"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.most_win_by_pokemon_trainer(pokemon_trainer)
    sql = "SELECT p.name, ps.win_count as most_win FROM pokemon_trainers ps JOIN pokemons p ON p.id = ps.pokemon_id
    WHERE trainer_id = #{pokemon_trainer} ORDER BY win_count DESC"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.most_lose_by_pokemon_trainer(pokemon_trainer)
    sql = "SELECT p.name, ps.lose_count as most_lose FROM pokemon_trainers ps JOIN pokemons p ON p.id = ps.pokemon_id
    WHERE trainer_id = #{pokemon_trainer} ORDER BY lose_count DESC"

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end

  def self.pokemon_win_rate_by_trainer(pokemon_trainer)
    sql = "SELECT p.name,
          case when ps.battle_count > 0
          then win_count*100/battle_count else 0  end
          FROM pokemon_trainers ps JOIN pokemons p ON p.id = ps.pokemon_id WHERE trainer_id = #{pokemon_trainer}
          "

    result = ActiveRecord::Base.connection.execute(sql)
    result.values
  end
end