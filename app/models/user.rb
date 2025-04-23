class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  
  belongs_to :grade, optional: true
  has_many :actualites
  has_many :objet_connectes

  # Callback pour mettre à jour le grade avant la sauvegarde
  before_save :update_grade

  # Méthode pour mettre à jour le grade
  def update_grade
    return if points.blank?

    self.grade = Grade.where("seuil_min_points <= ?", points).order(seuil_min_points: :desc).first
  end
end