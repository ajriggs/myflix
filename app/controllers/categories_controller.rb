class CategoriesController < ApplicationController
  def show
    @category = Category.find_by(slug: params[:id])
    render :genre
  end
end
