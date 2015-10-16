class PagesController < ApplicationController
  def front
    require_logout
  end
end
