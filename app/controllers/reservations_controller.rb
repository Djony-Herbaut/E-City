class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_complex_or_admin
  before_action :set_location, only: [:new, :create]
  before_action :set_reservation, only: [:new]
  before_action :prepare_available_slots, only: [:new, :create]

  def index
    @reservations = current_user.reservations.includes(:location).order(created_at: :desc)
  end

  def new
  end

  def create
    @reservation = current_user.reservations.new(reservation_params.merge(
      location: @location,
      status: Reservation::PENDING
    ))

    if @reservation.save
      redirect_to reservations_path, notice: "Réservation créée avec succès !"
    else
      render :new
    end
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
    
    unless @reservation.user == current_user || current_user.admin?
      redirect_to reservations_path, alert: "Vous n'avez pas accès à cette réservation"
      return
    end
    
  rescue ActiveRecord::RecordNotFound
    redirect_to reservations_path, alert: "Réservation non trouvée"
  end
  private

  def set_location
    @location = Location.find(params[:location_id])
  end

  def set_reservation
    @reservation = @location.reservations.new(
      status: Reservation::PENDING,
      start_time: Time.current.beginning_of_hour
    )
  end

  def prepare_available_slots
    @available_slots = generate_available_slots
  end

  def reservation_params
    params.require(:reservation).permit(:start_time, :end_time, :notes).tap do |whitelisted|
      # Calcul automatique de l'end_time si non fourni
      if whitelisted[:start_time].present? && whitelisted[:end_time].blank?
        start_time = Time.parse(whitelisted[:start_time])
        whitelisted[:end_time] = (start_time + 1.hour).to_s
      end
    end
  end

  def check_complex_or_admin
    unless current_user&.grade&.nom == 'Complexe' || current_user&.admin?
      redirect_to root_path, alert: "Accès réservé aux utilisateurs Complexe et Administrateurs"
    end
  end

  def generate_available_slots
    (9..18).map do |hour|
      start_time = Time.current.beginning_of_day + hour.hours
      formatted_time = start_time.strftime('%Y-%m-%d %H:%M:%S')
      ["#{hour}h - #{hour+1}h", formatted_time]
    end
  end
end