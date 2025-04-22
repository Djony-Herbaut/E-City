class Admin::ObjetConnectesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    @objet_connectes = ObjetConnecte.pending
  end

  def update
    @objet_connecte = ObjetConnecte.find(params[:id])

    case params[:commit]
    when "Valider"
      @objet_connecte.update(status: "approved")
    when "Rejeter"
      @objet_connecte.update(status: "rejected")
    end

    redirect_to admin_objet_connectes_path
  end

  private

  def check_admin!
    redirect_to root_path, alert: "Accès réservé aux administrateurs." unless current_user&.admin?
  end
end
