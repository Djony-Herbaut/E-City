class Location < ApplicationRecord
    has_many :reservations, dependent: :destroy
  end