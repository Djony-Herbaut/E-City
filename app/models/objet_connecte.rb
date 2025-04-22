class ObjetConnecte < ApplicationRecord
  belongs_to :user, optional: true

  has_one_attached :image # si tu utilises ActiveStorage

   # Scope pour récupérer les objets connectés avec un status spécifique
   scope :pending, -> { where(status: 0) }
   scope :approved, -> { where(status: 1) }
   scope :rejected, -> { where(status: 2) }

end
