module TrainersHelper
  def trainer_params
    params.require(:trainer).permit(:name, :email, :password_digest)
  end

  def pokemon_trainer_params
    params.require(:pokemon_trainer).permit(:pokemon_id)
  end
end
