class Admin::ObjetConnectesController < ApplicationController
  def index
    @objets = ObjetConnecte.all
  end

  def update
    @objet = ObjetConnecte.find(params[:id])
  
    if params[:commit] == "Valider"
      @objet.update(status: 1)
      @objet.user.increment!(:points, 50) if @objet.user.present?
    elsif params[:commit] == "Rejeter"
      @objet.update(status: 2)
    end
  
    respond_to do |format|
      format.js
      format.html { head :no_content } 
    end
  end  

end
