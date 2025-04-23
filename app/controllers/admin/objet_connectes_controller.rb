class Admin::ObjetConnectesController < ApplicationController
  def index
    @objets = ObjetConnecte.all
  end

  def update
    @objet = ObjetConnecte.find(params[:id])
    if params[:commit] == "Valider"
      @objet.update(status: 1)
    elsif params[:commit] == "Rejeter"
      @objet.update(status: 2)
    end
    redirect_to admin_root_path
  end
end
