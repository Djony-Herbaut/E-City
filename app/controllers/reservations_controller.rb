class ReservationsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_complex_or_admin
    before_action :set_location, only: [:new, :create]
  
    def index
      @reservations = current_user.reservations.includes(:location).order(created_at: :desc)
    end
  
    def new
      @reservation = Reservation.new(status: Reservation::PENDING)
      @available_slots = generate_available_slots
    end
  
    def create
        start_time = Time.zone.parse(params[:reservation][:start_time])
        
        @reservation = current_user.reservations.new(
          start_time: start_time,
          end_time: start_time + 1.hour,
          location: @location,
          status: Reservation::PENDING,
          notes: params[:reservation][:notes]
        )
      
        if @reservation.save
          redirect_to reservations_path, notice: "Réservation créée !"
        else
          puts "DEBUG - Erreurs: #{@reservation.errors.full_messages}"
          @available_slots = generate_available_slots
          render :new
        end
    end
  
    private
  
    def set_location
      @location = Location.find(params[:location_id])
    end
  
    def reservation_params
        params.require(:reservation).permit(:start_time, :notes)
    end
  
    def check_complex_or_admin
      unless current_user&.grade&.nom == 'Complexe' || current_user&.admin?
        redirect_to root_path, alert: "Accès réservé aux utilisateurs Complexe et Administrateurs"
      end
    end
  
    def generate_available_slots
        (9..18).map do |hour|
          start_time = Time.current.beginning_of_day + hour.hours
          ["#{hour}h - #{hour+1}h", start_time.iso8601]
        end
    end
end