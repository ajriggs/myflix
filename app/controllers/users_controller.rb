class UsersController < ApplicationController
  def welcome

  end

  def new
    render :register
  end
end
