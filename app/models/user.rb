class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  belongs_to :grade, optional: true
  has_many :actualites
  has_many :objet_connectes
  has_many :incidents, dependent: :destroy
  has_many :reservations

  # Callback pour mettre à jour le grade et le statut admin avant la sauvegarde
  before_save :update_grade_and_admin_status

  # Méthode pour mettre à jour le grade et le statut admin
  def update_grade_and_admin_status
    return if points.blank?

    # Mise à jour du grade en fonction des points
    self.grade = Grade.where("seuil_min_points <= ?", points).order(seuil_min_points: :desc).first

    # Si le grade est 'Administrateur', on donne également le statut admin
    if self.grade&.nom == 'Administrateur'
      self.admin = true
    end
  end
end