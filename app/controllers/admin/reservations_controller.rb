class Admin::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    @pending_reservations = Reservation.pending.includes(:user, :location)
    @approved_reservations = Reservation.approved.includes(:user, :location).order(created_at: :desc)
    @rejected_reservations = Reservation.rejected.includes(:user, :location).order(created_at: :desc)
  end

  def update
    @reservation = Reservation.find(params[:id])
    
    case params[:status]
    when 'approved'
      @reservation.update(status: Reservation::APPROVED)
    when 'rejected'
      @reservation.update(status: Reservation::REJECTED)
    end

    respond_to do |format|
      format.html { redirect_to admin_reservations_path, notice: "Statut mis à jour" }
      format.js
    end
  end

  private

  def check_admin!
    unless current_user.admin?
      redirect_to root_path, alert: "Accès réservé aux administrateurs"
    end
  end
end