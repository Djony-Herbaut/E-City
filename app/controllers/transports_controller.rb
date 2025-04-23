class TransportsController < ApplicationController
    before_action :set_user_access_level
  
    def index
      @locations = Location.all
      
      # Filtres de base pour tous les utilisateurs
      @locations = @locations.where(category: params[:category]) if params[:category].present?
      @locations = @locations.where(status: params[:status]) if params[:status].present?
  
      # Filtre supplémentaire pour utilisateurs complexes et admins
      if @access_level >= 1 && params[:neighborhood].present?
        @locations = @locations.where(neighborhood: params[:neighborhood])
      end
  
      # Tri et pagination
      @locations = @locations.order(:name).page(params[:page]).per(12)
  
      # Préparation des options de filtre
      @categories = Location.distinct.pluck(:category).compact
      @statuses = Location.distinct.pluck(:status).compact
      @neighborhoods = Location.distinct.pluck(:neighborhood).compact if @access_level >= 1
    end
  
    def schedules
      @lines = Location.where.not(transport_line: nil)
                       .distinct
                       .pluck(:transport_line, :transport_type)
                       .sort_by { |line, type| line.to_i }
    end
  
    private
  
    def set_user_access_level
      # 0 = simple, 1 = complexe, 2 = admin
      @access_level = if current_user&.admin?
                        2
                      elsif current_user&.grade&.nom == 'Complexe'
                        1
                      else
                        0
                      end
    end
  end