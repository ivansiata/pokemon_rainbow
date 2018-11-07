class StaticPagesController < ApplicationController
  def home
    add_breadcrumb "Home", root_path, title: "Home"
    @element = params[:element_type]
    if @element.nil?
      @element = "global"
    end
  end

  def bar

  end
end
