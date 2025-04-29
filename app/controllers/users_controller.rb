class UsersController < ApplicationController
  def show
    @user = current_user
    @actualites_utilisateur = @user.actualites.order(created_at: :desc)
    @objets_utilisateur = current_user.objet_connectes

    @current_grade = @user.grade
    @next_grade = Grade.where("seuil_min_points > ?", @user.points).order(:seuil_min_points).first
    @progress_percent = if @next_grade
                          100 * (@user.points - @current_grade.seuil_min_points).to_f / (@next_grade.seuil_min_points - @current_grade.seuil_min_points)
                        else
                          100
                        end

    if current_user.admin?
      @pending_objets = ObjetConnecte.pending
      @approved_objets = ObjetConnecte.approved
      @rejected_objets = ObjetConnecte.rejected
    end
  end
end
