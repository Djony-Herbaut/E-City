class ObjetConnecte < ApplicationRecord
  belongs_to :user, optional: true

  # enum status: { pending: 0, approved: 1, rejected: 2 }

  has_one_attached :image # si tu utilises ActiveStorage

  scope :pending, -> { where(status: 0) }

end
