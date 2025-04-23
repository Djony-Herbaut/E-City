class ObjetConnectesController < ApplicationController
  def index
    @objets = ObjetConnecte.where(status: 1) # Affiche seulement ceux validés
  end
end
