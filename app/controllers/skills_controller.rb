class SkillsController < ApplicationController
  include SkillsHelper

  def index
    @skills = Skill.paginate(page: params[:page], per_page:5)
  end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      flash[:success] = "Skill '#{@skill.name}' created!"
      redirect_to skill_path(@skill)
    else
      render 'new'
    end
  end

  def show
    @skill = Skill.find(params[:id])
  end

  def edit
    @skill = Skill.find(params[:id])
  end

  def update
    @skill = Skill.find(params[:id])
    if @skill.update(skill_params)
      flash[:success] = "Skill '#{@skill.name}' updated!"
      redirect_to skill_path(@skill)
    else
      render 'edit'
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy
    flash[:success] = "Skill '#{@skill.name}' destroyed!"
    redirect_to skills_path
  end
end
