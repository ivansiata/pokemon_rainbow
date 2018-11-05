class PokedexesController < ApplicationController
  include PokedexesHelper

  def index
    add_breadcrumb "Pokedexes", pokedexes_path, title: "Back to the Index"
    @pokedexes = Pokedex.paginate(page: params[:page], per_page:5)
  end

  def new
    add_breadcrumb "Pokedexes", pokedexes_path, title: "Back to the Index"
    add_breadcrumb "New Pokedex", new_pokedex_path, title: "Create new Pokedex"
    @pokedex = Pokedex.new
  end

  def create
    @pokedex = Pokedex.new(pokedex_params)
    if @pokedex.save
      flash[:success] = "Pokedex '#{@pokedex.name}' created!"
      redirect_to pokedex_path(@pokedex)
    else
      render 'new'
    end
  end

  def show
    @pokedex = Pokedex.find(params[:id])
  end

  def edit
    @pokedex = Pokedex.find(params[:id])
  end

  def update
    @pokedex = Pokedex.find(params[:id])
    if @pokedex.update(pokedex_params)
      flash[:success] = "Pokedex '#{@pokedex.name}' updated!"
      redirect_to pokedex_path(@pokedex)
    else
      render 'edit'
    end
  end

  def destroy
    @pokedex = Pokedex.find(params[:id])
    @pokedex.destroy
    flash[:success] = "Pokedex '#{@pokedex.name}' destroyed!"
    redirect_to pokedexes_path
  end

end
