class CategoriesController < ApplicationController
  before_action :require_login
  def show
    @category = Category.find_by(slug: params[:id])
  end
end
