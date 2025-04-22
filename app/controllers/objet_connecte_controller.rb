class ObjetConnectesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_objet_connecte, only: %i[show edit update destroy]

  def index
    @objet_connectes = current_user.objet_connectes
  end

  def new
    @objet_connecte = ObjetConnecte.new
  end

  def create
    @objet_connecte = current_user.objet_connectes.build(objet_connecte_params)
    @objet_connecte.status = 'pending'

    if @objet_connecte.save
      redirect_to objet_connectes_path, notice: 'Votre requête a été soumise.'
    else
      render :new
    end
  end

  def show; end

  def destroy
    @objet_connecte.destroy
    redirect_to objet_connectes_path, notice: 'Requête supprimée.'
  end

  private

  def set_objet_connecte
    @objet_connecte = ObjetConnecte.find(params[:id])
  end

  def objet_connecte_params
    params.require(:objet_connecte).permit(:titre, :description, :image)
  end
end
