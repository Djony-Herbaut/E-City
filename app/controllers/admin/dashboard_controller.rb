class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    @pending_objets = ObjetConnecte.pending
  end

  private

  def check_admin!
    redirect_to root_path, alert: "Accès réservé aux administrateurs." unless current_user&.admin?
  end
end
