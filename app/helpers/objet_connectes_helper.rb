module ObjetConnectesHelper
  def status_to_text(status)
    case status
    when 0 then "En attente"
    when 1 then "Validé"
    when 2 then "Rejeté"
    else "Inconnu"
    end
  end  
end
