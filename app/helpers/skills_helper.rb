module SkillsHelper
  def skill_params
    params.require(:skill).permit(:name, :power, :max_pp, :element_type)
  end
end
