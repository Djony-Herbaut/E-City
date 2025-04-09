class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  belongs_to :grade, optional: true
  has_many :actualites

  # Callback pour mettre à jour le grade après l'enregistrement
  after_save :update_grade
  
  # Méthode pour mettre à jour le grade
  def update_grade
    self.grade = Grade.where("seuil_min_points <= ?", self.points).order(seuil_min_points: :desc).first
    save if grade_id_changed?
  end
end