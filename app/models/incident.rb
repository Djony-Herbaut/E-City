class Incident < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :incident_type, inclusion: { in: %w(Problème\ technique Retard Autre) }
  validates :points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Limiter le nombre d'incidents signalés par heure sur une ligne et un arrêt
  validate :limit_incidents_per_hour, on: :create

  # Gérer l'heure de l'incident pour maintenir le retard
  after_create :keep_delay_on_incident

  private

  def limit_incidents_per_hour
    incidents_count = Incident.where(location: location, created_at: 1.hour.ago..Time.now).count
    if incidents_count >= 2
      errors.add(:base, "Vous avez atteint la limite de signalements pour cette ligne ou cet arrêt par heure.")
    end
  end

  def keep_delay_on_incident
    location.update_attribute(:incident_reported_at, Time.current)
  end
end
