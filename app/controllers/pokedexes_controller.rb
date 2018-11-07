class PokedexesController < ApplicationController
  include PokedexesHelper

  def index
    @pokedexes = Pokedex.paginate(page: params[:page], per_page:5)
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokedex List", pokedexes_path, title: "Pokedex List"
  end

  def new
    @pokedex = Pokedex.new
    add_breadcrumb "Home", root_path, title: "Home"
    add_breadcrumb "Pokedex List", pokedexes_path, title: "Back to Pokedex List"
    add_breadcrumb "New Pokedex", new_pokedex_path, title: "Create New Pokedex"
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
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokedex List", pokedexes_path, title: "Back to Pokedex List"
    add_breadcrumb @pokedex.name, pokedex_path(@pokedex)

  end

  def edit
    @pokedex = Pokedex.find(params[:id])
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Pokedex List", pokedexes_path, title: "Back to Pokedex List"
    add_breadcrumb @pokedex.name, edit_pokedex_path(@pokedex)
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
