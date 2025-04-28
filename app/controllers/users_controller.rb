class UsersController < ApplicationController
  def show
    @user = current_user
    @actualites_utilisateur = @user.actualites.order(created_at: :desc)
    @objets_utilisateur = current_user.objet_connectes

    if current_user.admin?
      @pending_objets = ObjetConnecte.pending
      @approved_objets = ObjetConnecte.approved
      @rejected_objets = ObjetConnecte.rejected
    end
  end
  
end
