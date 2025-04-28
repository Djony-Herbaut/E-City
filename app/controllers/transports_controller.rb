class TransportsController < ApplicationController
  before_action :set_user_access_level

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

  private

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
