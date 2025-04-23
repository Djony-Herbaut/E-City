class ObjetConnectesController < ApplicationController
  def index
    @objets = ObjetConnecte.where(status: 1) # Affiche seulement ceux validés
  end

  def new
    @objet_connecte = ObjetConnecte.new
  end
  
  def create
    @objet_connecte = current_user.objet_connectes.build(objet_connecte_params)
    @objet_connecte.status = 0 # forcé à "pending"
    
    if @objet_connecte.save
      redirect_to objet_connectes_path, notice: "Objet ajouté avec succès."
    else
      render :new
    end
  end
  
  
  private
  
  def objet_connecte_params
    params.require(:objet_connecte).permit(:titre, :description, :image, :status)
  end
  
end
