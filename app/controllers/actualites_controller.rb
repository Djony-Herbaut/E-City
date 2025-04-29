class ActualitesController < ApplicationController
  before_action :set_actualite, only: %i[ show edit update destroy ]
  
  def index
    @actualites = Actualite.all
  end

  
  def show
  end

  def new
    @actualite = Actualite.new
  end

  
  def edit
  end

  def create
    @actualite = current_user.actualites.build(actualite_params)

    respond_to do |format|
      if @actualite.save
        # Ajout de 50 points pour la création de l'actualité
        current_user.increment!(:points, 50)
        format.html { redirect_to @actualite, notice: "Actualité créée avec succès. +50 points ajoutés à ton compte !" }
        format.json { render :show, status: :created, location: @actualite }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @actualite.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      first_edit = (@actualite.created_at == @actualite.updated_at)
  
      if @actualite.update(actualite_params)
        if first_edit
          current_user.increment!(:points, 25)
          notice_message = "Actualité modifiée pour la première fois. +25 points ajoutés !"
        else
          notice_message = "Actualité mise à jour."
        end
  
        format.html { redirect_to @actualite, notice: notice_message }
        format.json { render :show, status: :ok, location: @actualite }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @actualite.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @actualite.destroy!

    respond_to do |format|
      format.html { redirect_to actualites_path, status: :see_other, notice: "L'actualité à été supprimer correctement !" }
      format.json { head :no_content }
    end
  end

  private
    def set_actualite
      @actualite = Actualite.find(params[:id])
    end

    def actualite_params
      params.require(:actualite).permit(:titre, :contenu, :image)
    end    
end