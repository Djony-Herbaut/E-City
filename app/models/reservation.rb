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
  scope :in_time_range, ->(from, to) {
    where(
      "start_time BETWEEN ? AND ?",
      from.strftime('%Y-%m-%d %H:%M:%S'),
      to.strftime('%Y-%m-%d %H:%M:%S')
    )
  }

  before_validation :normalize_times
  validate :times_format_valid
  validates :status, inclusion: { in: [PENDING, APPROVED, REJECTED] }
  validates :start_time, :end_time, presence: true
  validate :valid_time_slot  
  validate :not_overlapping
  validate :end_time_is_one_hour_after_start_time

  after_update :award_points_if_approved, if: :saved_change_to_status?

  def time_slot
    "#{formatted_time(start_time)} - #{formatted_time(end_time)}"
  end

  def formatted_start_time
    return unless start_time.present?
    
    begin
      # Pour Rails 8.0.x, utilisez to_s(:long) au lieu de to_formatted_s(:long)
      Time.zone.parse(start_time).to_s(:long)
    rescue ArgumentError
      # Fallback: affiche la date brute si le parsing échoue
      start_time
    end
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

  def formatted_time(time_str)
    return "N/A" unless time_str.present?
    
    begin
      time = Time.zone.parse(time_str)
      time.strftime('%H:%M')
    rescue ArgumentError
      time_str
    end
  end

  def normalize_times
    self.start_time = parse_and_format_time(start_time)
    self.end_time = parse_and_format_time(end_time)
  end

  def parse_and_format_time(time)
    return nil if time.blank?
    
    if time.is_a?(String)
      Time.zone.parse(time).strftime('%Y-%m-%d %H:%M:%S')
    else
      time.in_time_zone('Paris').strftime('%Y-%m-%d %H:%M:%S')
    end
  rescue ArgumentError
    nil
  end

  def times_format_valid
    errors.add(:start_time, "format invalide") unless valid_time_string?(start_time)
    errors.add(:end_time, "format invalide") unless valid_time_string?(end_time)
  end

  def valid_time_string?(time_str)
    return false if time_str.blank?
    !!time_str.match(/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/)
  end


  def valid_time_slot
    return unless start_time && end_time
    
    start = Time.parse(start_time) rescue nil
    ending = Time.parse(end_time) rescue nil
    
    unless start && ending && start.hour.between?(9, 18) && (ending - start) == 3600
      errors.add(:base, "Les réservations doivent être entre 9h et 19h par créneaux d'1 heure")
    end
  end

  def not_overlapping
    return unless location && start_time && end_time
  
    overlapping = Reservation.approved
                          .where(location_id: location_id)
                          .where.not(id: id)
                          .where("start_time < ? AND end_time > ?", end_time, start_time)
                          .exists?
  
    if overlapping
      errors.add(:base, "Un créneau existe déjà entre #{display_time(start_time)} et #{display_time(end_time)}")
    end
  end

  def award_points_if_approved
    return unless status == APPROVED
    user.increment!(:points, 100)
  end

  def end_time_is_one_hour_after_start_time
    return unless start_time && end_time
    
    begin
      unless Time.parse(end_time) == Time.parse(start_time) + 3600
        errors.add(:end_time, "doit être exactement 1 heure après l'heure de début")
      end
    rescue ArgumentError
      errors.add(:end_time, "format de temps invalide")
    end
  end

  def display_time(time_str)
    Time.parse(time_str).strftime('%H:%M') rescue time_str
  end
end