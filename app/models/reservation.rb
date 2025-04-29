class Reservation < ApplicationRecord
  belongs_to :location
  belongs_to :user, optional: false

  # Constantes pour les statuts
  PENDING = 0
  APPROVED = 1
  REJECTED = 2

  # Scopes pour filtrer
  scope :pending, -> { where(status: PENDING) }
  scope :approved, -> { where(status: APPROVED) }
  scope :rejected, -> { where(status: REJECTED) }
  scope :in_time_range, ->(start_time, end_time) {
    where("datetime(start_time) BETWEEN datetime(?) AND datetime(?)", 
          start_time.in_time_zone('Paris').to_s(:db),
          end_time.in_time_zone('Paris').to_s(:db))
  }

  validates :status, inclusion: { in: [PENDING, APPROVED, REJECTED] }
  validates :start_time, :end_time, presence: true
  validate :valid_time_slot
  validate :not_overlapping
  validate :end_time_is_one_hour_after_start_time

  before_save :convert_to_paris_time
  after_update :award_points_if_approved, if: :saved_change_to_status?

  def time_slot
    "#{start_time.strftime('%H:%M')} - #{end_time.strftime('%H:%M')}"
  end

  def status_text
    case status
    when PENDING then 'En attente'
    when APPROVED then 'Approuvé'
    when REJECTED then 'Rejeté'
    else 'Inconnu'
    end
  end

  private

  def valid_time_slot
    return unless start_time && end_time
    
    unless start_time.hour.between?(9, 18) && end_time.hour == start_time.hour + 1
      errors.add(:base, "Les réservations doivent être entre 9h et 19h par créneaux d'1 heure")
    end
  end

  def not_overlapping
    return unless location && start_time && end_time
  
    overlapping = Reservation.approved
                           .where(location_id: location_id)
                           .where.not(id: id)
                           .where("(? < end_time) AND (? > start_time)", 
                                 end_time.to_i, start_time.to_i)
                           .exists?
  
    if overlapping
      errors.add(:base, "Un créneau existe déjà entre #{start_time.strftime('%H:%M')} et #{end_time.strftime('%H:%M')}")
    end
  end

  def award_points_if_approved
    return unless status == APPROVED

    user.increment!(:points, 100)
  end

  def end_time_is_one_hour_after_start_time
    return unless start_time && end_time
    
    unless end_time == start_time + 1.hour
      errors.add(:end_time, "doit être exactement 1 heure après l'heure de début")
    end
  end

  def convert_to_paris_time
    self.start_time = start_time.in_time_zone('Paris') if start_time
    self.end_time = end_time.in_time_zone('Paris') if end_time
  end
end