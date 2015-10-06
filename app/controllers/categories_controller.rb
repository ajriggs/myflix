class CategoriesController < ApplicationController
  def index
    @categories = Category.all
    render :home
  end

  def show
    @category = Category.find_by(slug: params[:id])
    render :genre
  end
end
