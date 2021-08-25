class IdeasController < ApplicationController
  
  def index
    if Category.exists?(name: params[:category_name])
      category = Category.find_by(name:params[:category_name])
      ideas = Idea.where(category_id: category.id).includes(:category)
      render json: { data: set_response(ideas) }
    else
      ideas = Idea.all.includes(:category)
      render json: { data: set_response(ideas) }
    end
  end

  def create
    if params[:category_name].present? && params[:body].present?
      if Category.exists?(name: params[:category_name])
        category = Category.find_by(name: params[:category_name])
        idea = Idea.create(idea_params(category.id))
        render status: :created
      else
        category = Category.create(name: params[:category_name])
        idea = Idea.create(idea_params(category.id))
        render status: :created
      end
    else
      render status: :unprocessable_entity
    end
  end

  private

  def set_response(ideas)
    require'time'
    ideas_res = ideas.map do |idea| 
      {id: idea.id, category: idea.category.name, body: idea.body, created_at: idea.created_at.to_i}
    end
    return ideas_res
  end

  def idea_params(id)
    params.permit(:body).merge(category_id: id)
  end
end
