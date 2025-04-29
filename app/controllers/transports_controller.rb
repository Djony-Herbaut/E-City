class TransportsController < ApplicationController
  before_action :set_user_access_level

  helper_method :formatted_delay

  def index
    # Affiche uniquement les lieux de transport
    @locations = Location.where(category: 'transport')

    # Filtres
    @locations = @locations.where(status: params[:status]) if params[:status].present?
    @locations = @locations.where(neighborhood: params[:neighborhood]) if params[:neighborhood].present?
    @locations = @locations.where(location_type: params[:type]) if params[:type].present?
    @locations = @locations.where(transport_line: params[:line]) if params[:line].present?

    # Préparation des options pour les filtres
    @statuses = @locations.distinct.pluck(:status).compact
    @neighborhoods = @locations.distinct.pluck(:neighborhood).compact
    @types = @locations.distinct.pluck(:location_type).compact
    @lines = @locations.where.not(transport_line: nil).distinct.pluck(:transport_line).compact.sort

    # Tri et pagination
    @locations = @locations.order(:name).page(params[:page]).per(12)
  end

  def schedules
    @lines = Location.where(category: 'transport')
  
    # Appliquer les filtres si présents
    @lines = @lines.where(transport_line: params[:line]) if params[:line].present?
    @lines = @lines.where(location_type: params[:transport_type]) if params[:transport_type].present?
    @lines = @lines.where(name: params[:stop]) if params[:stop].present?
  
    # Récupérer lignes + types sans doublons
    @lines = @lines.distinct.pluck(:transport_line, :location_type).compact.sort
  
    # Si on veut afficher tous les arrêts filtrés aussi :
    if params[:line].present?
      @stops = Location.where(transport_line: params[:line]).order(:name).pluck(:name)
    else
      @stops = []
    end
  end

  def formatted_delay(location)
    if location.schedule.nil?
      return "Horaire non défini"
    elsif location.schedule > Time.current
      delay = location.schedule - Time.current
      if delay > 1.hour
        return "#{(delay / 1.hour).round(2)} heures"
      else
        return "#{(delay / 1.minute).to_i} minutes"
      end
    else
      return "À l'heure"
    end
  end

  def report_incident
    @location = Location.find(params[:id])
    @incident = current_user.incidents.build(location: @location, incident_type: params[:incident_type], points: 150)

    if @incident.save
      # Décaler les horaires de la ligne et des arrêts en cas d'incident
      adjust_schedule(@location)
      redirect_to horaires_path, notice: "Incident signalé avec succès et points attribués !"
    else
      redirect_to horaires_path, alert: @incident.errors.full_messages.to_sentence
    end
  end

  private

  def adjust_schedule(location)
    locations_on_line = Location.where(transport_line: location.transport_line)
    locations_on_line.each do |loc|
      # Si l'horaire est déjà défini, ajoute un certain retard
      if loc.schedule.present?
        new_schedule = loc.schedule + 10.minutes # Ajout de 10 minutes pour simuler le retard
        loc.update_attribute(:schedule, new_schedule)
      else
        # Si l'horaire est nil, on peut définir l'heure actuelle
        loc.update_attribute(:schedule, Time.current + 10.minutes)
      end
    end
  end

  def set_user_access_level
    @access_level = if current_user&.admin?
                      2
                    elsif current_user&.grade&.nom == 'Complexe'
                      1
                    else
                      0
                    end
  end
end