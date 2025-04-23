class HomeController < ApplicationController
  def index
    @actualites = Actualite.all.order(created_at: :desc).limit(5)
    @objets_connectes = ObjetConnecte.where(status: 1) # Affiche seulement ceux validés
  end
end