class SkillsController < ApplicationController
  include SkillsHelper

  def index
    @skills = Skill.paginate(page: params[:page], per_page:5)

    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Skills", skills_path, title: "Skill List"
  end

  def new
    @skill = Skill.new

    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Skills", skills_path, title: "Back to Skill List"
    add_breadcrumb "New Skill", new_skill_path, title: "New Skill"
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
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Skills", skills_path, title: "Back to Skill List"
    add_breadcrumb @skill.name, skill_path(@skill)
  end

  def edit
    @skill = Skill.find(params[:id])
    add_breadcrumb "Home", root_path, title: "Back to Home"
    add_breadcrumb "Skills", skills_path, title: "Back to Skill List"
    add_breadcrumb @skill.name, edit_skill_path(@skill)
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
