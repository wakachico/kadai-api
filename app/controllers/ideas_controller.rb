class IdeasController < ApplicationController
  def index
    ideas = Idea.all.includes(:category)
    render json: { data: ideas }
  end

  def create
    
  end
end
