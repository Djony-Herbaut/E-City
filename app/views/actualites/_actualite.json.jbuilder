json.extract! actualite, :id, :titre, :contenu, :image, :user_id, :created_at, :updated_at
json.url actualite_url(actualite, format: :json)
