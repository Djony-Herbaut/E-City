# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Grade.create(nom: 'Simple', seuil_min_points: 0)
Grade.create(nom: 'Complexe', seuil_min_points: 1000)
Grade.create(nom: 'Administrateur', seuil_min_points: 70000)
require 'csv'

Location.delete_all

csv_path = Rails.root.join('db', 'E_city_adresses.csv')
CSV.foreach(csv_path, headers: true) do |row|
  Location.create!(
    id: row['id'],
    category: row['categorie'],
    location_type: row['type'],
    name: row['nom'],
    address: row['adresse'],
    area: row['superficie'].presence,
    neighborhood: row['quartier'],
    status: row['statut'],
    latitude: row['latitude'],
    longitude: row['longitude'],
    transport_line: row['ligne_transport'],
    transport_type: row['type_transport']
  )
end
puts "Import terminé : #{Location.count} lieux créés."