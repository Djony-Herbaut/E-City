class HomeController < ApplicationController
  def index
    @actualites = Actualite.all.order(created_at: :desc).limit(5)
  end
end