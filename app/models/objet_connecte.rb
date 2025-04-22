class ObjetConnecte < ApplicationRecord
  belongs_to :user

  enum status: { pending: 'pending', approved: 'approved', rejected: 'rejected' }

  has_one_attached :image # si tu utilises ActiveStorage
end
