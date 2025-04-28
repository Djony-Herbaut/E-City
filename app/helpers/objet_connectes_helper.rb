module ObjetConnectesHelper
  def status_to_text(status)
    case status
    when "pending", 0
      "En attente"
    when "approved", 1
      "Approuvé"
    when "rejected", 2
      "Refusé"
    else
      "Inconnu"
    end
  end
  
  def status_class(status)
    case status
    when "pending", 0
      "status-pending"
    when "approved", 1
      "status-approved"
    when "rejected", 2
      "status-rejected"
    else
      ""
    end
  end
end
