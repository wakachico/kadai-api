class IdeasController < ApplicationController
  def index
    if Category.exists?(name: params[:category_name])
      category = Category.find_by(name: params[:category_name])
      ideas = Idea.where(category_id: category.id).includes(:category)
      render json: { data: res(ideas) }
    elsif params[:category_name].empty?
      ideas = Idea.all.includes(:category)
      render json: { data: res(ideas) }
    else
      render status: :not_found
    end
  end

  def create
    if params[:category_name].present? && params[:body].present?
      category =  if Category.exists?(name: params[:category_name])
                    Category.find_by(name: params[:category_name])
                  else
                    Category.create(name: params[:category_name])
                  end
      Idea.create(idea_params(category.id))
      render status: :created
    else
      render status: :unprocessable_entity
    end
  end

  private

  def res(ideas)
    ideas.map do |idea|
      { id: idea.id, category: idea.category.name, body: idea.body, created_at: idea.created_at.to_i }
    end
  end

  def idea_params(id)
    params.permit(:body).merge(category_id: id)
  end
end
