class PokemonBattleLogsController < ApplicationController
  def show
    @pokemon_battle_logs = PokemonBattleLog.where(pokemon_battle_id: params[:id])
  end

end
