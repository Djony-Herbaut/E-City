class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nom, :prenom, :points])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nom, :prenom, :points])
  end

  # Redirection après connexion
  def after_sign_in_path_for(resource)
    root_path # Redirige vers l'index (home#index)
  end

  # Redirection après déconnexion
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
