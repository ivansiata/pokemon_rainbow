class TrainersController < ApplicationController
  include TrainersHelper

  def index
    @trainers = Trainer.paginate(page: params[:page], per_page:5)
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Trainers", trainers_path, title: "Trainer List"
  end

  def new
    @trainer = Trainer.new
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Trainers", trainers_path, title: "Back to Trainer List"
    add_breadcrumb "New Trainer", new_trainer_path, title: "Create New trainer"
  end

  def create
    @trainer = Trainer.new(trainer_params)
    if @trainer.save
      flash[:success] = "Trainer '#{@trainer.name}' created!"
      redirect_to trainer_path(@trainer)
    else
      render 'new'
    end
  end

  def show
    @trainer = Trainer.find(params[:id])
    @pokemon_trainer = PokemonTrainer.new
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Trainer List", trainers_path, title: "Back to Trainer List"
    add_breadcrumb @trainer.name, trainer_path(@trainer)
  end

  def create_pokemon_trainer
    @pokemon_trainer = PokemonTrainer.new(pokemon_trainer_params)
    @trainer = Trainer.find(params[:id])
    if params[:pokemon_trainer][:pokemon_id].present?
      @pokemon_trainer.pokemon_id = params[:pokemon_trainer][:pokemon_id]
      @pokemon_trainer.trainer_id = @trainer.id

      if @pokemon_trainer.save
        flash[:success] = "Pokemon #{@pokemon_trainer.pokemon.name} Added!"
        redirect_to trainer_path(@trainer)
      else
        render 'show'
      end

    else
        flash.now[:danger] = "Skill cannot be empty"
        render 'show'
    end
  end

  def destroy_pokemon_trainer
    @pokemon_trainer = PokemonTrainer.find_by(pokemon_id: params[:id], pokemon_id: params[:pokemon_id])
    @pokemon_trainer.destroy
    flash[:success] = "Pokemon #{@pokemon_trainer.pokemon.name} Destroyed!"
    redirect_to trainer_path(@pokemon_trainer.trainer_id)
  end

end
