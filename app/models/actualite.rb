class Actualite < ApplicationRecord
  belongs_to :user
end

has_one_attached :image