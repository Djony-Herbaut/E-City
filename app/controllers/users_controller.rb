class UsersController < ApplicationController
  def show
    @user = current_user
    @actualites_utilisateur = @user.actualites.order(created_at: :desc)
  end
end
