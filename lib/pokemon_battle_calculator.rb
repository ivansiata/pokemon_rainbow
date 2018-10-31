class PokemonBattleCalculator
  RESISTANCE_LIST = {
       normal: {
           rock: 0.5,
           ghost: 0,
           steel: 0.5
       },
       fighting: {
           normal: 2,
           flying: 0.5,
           poison: 0.5,
           rock: 2,
           bug: 0.5,
           ghost: 0,
           steel: 2,
           psychic: 0.5,
           ice: 2,
           dark: 2,
           fairy: 0.5
       },
       flying: {
           fighting: 2,
           rock: 0.5,
           bug: 2,
           steel: 0.5,
           grass: 2,
           electric: 0.5,
       },
       poison: {
           poison: 0.5,
           ground: 0.5,
           rock: 0.5,
           ghost: 0.5,
           steel: 0,
           grass: 2,
           fairy: 2
       },
       ground: {
           flying: 0,
           poison: 2,
           rock: 2,
           bug: 0.5,
           steel: 2,
           fire: 2,
           grass: 0.5,
           electric: 2
       },
       rock: {
           fighting: 0.5,
           flying: 2,
           ground: 0.5,
           bug: 2,
           steel: 0.5,
           fire: 2,
           ice: 2
       },
       bug: {
           fighting: 0.5,
           flying: 0.5,
           poison: 0.5,
           ghost: 0.5,
           steel: 0.5,
           fire: 0.5,
           grass: 2,
           psychic: 2,
           dark: 2,
           fairy: 0.5
       },
       ghost: {
           normal: 0,
           ghost: 2,
           psychic: 2,
           dark: 0.5
       },
       steel: {
           rock: 2,
           steel: 0.5,
           fire: 0.5,
           water: 0.5,
           electric: 0.5,
           ice: 2,
           fairy: 2
       },
       fire: {
           rock: 0.5,
           bug: 2,
           steel: 2,
           fire: 0.5,
           water: 0.5,
           grass: 2,
           ice: 2,
           dragon: 0.5
       },
       water: {
           ground: 2,
           rock: 2,
           fire: 2,
           water: 0.5,
           grass: 0.5,
           dragon: 0.5
       },
       grass:{
           flying: 0.5,
           poison: 0.5,
           ground: 2,
           rock: 2,
           bug: 0.5,
           steel: 0.5,
           fire:0.5,
           water: 2,
           grass: 0.5,
           dragon: 0.5
       },
       electric: {
           flying: 2,
           ground: 0,
           water: 2,
           grass: 0.5,
           electric: 0.5,
           dragon: 0.5
       },
       psychic: {
           flying: 2,
           ground: 2,
           steel: 0.5,
           psychic: 0.5,
           dark: 0
       },
       ice: {
           flying: 2,
           ground: 2,
           steel: 0.5,
           fire: 0.5,
           water: 0.5,
           grass: 2,
           ice: 0.5,
           dragon: 2
       },
       dragon: {
           steel: 0.5,
           dragon: 2,
           fairy: 0
       },
       dark: {
           fighting: 0.5,
           ghost: 2,
           psychic: 2,
           dark: 0.5,
           fairy: 0.5
       },
       fairy: {
           fighting: 2,
           poison: 0.5,
           steel: 0.5,
           fire: 0.5,
           dragon: 2,
           dark: 2
       }
  }

  Stats = Struct.new(:health_point, :attack_point, :defence_point, :speed_point)

  def self.calculate_damage(attacker, defender, skill)
    stab = (skill.element_type == attacker.pokedex.element_type) ? 1.5 : 1
    resistance = RESISTANCE_LIST[skill.element_type.to_sym][defender.pokedex.element_type.to_sym]
    resistance = 1 if resistance.nil?
    damage = (((((2 * attacker.level.to_f / 5 + 2) * attacker.attack * skill.power / defender.defence) / 50) + 2) * stab * resistance * (rand(85..100).to_f / 100)).round
  end

  def self.calculate_experience(enemy_level)
    gain = rand(20..150) * enemy_level
  end

  def self.level_up?(winner_level, total_experience)
    limit = 2**winner_level * 100
    if total_experience >= limit
      return true
    else
      return false
    end
  end

  def self.calculate_level_up_extra_stats
    output = Stats.new(rand(10..20), rand(1..5), rand(1..5), rand(1..5))
  end

end

