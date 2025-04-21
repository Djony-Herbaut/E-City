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
    @actualite = Actualite.new(actualite_params)

    respond_to do |format|
      if @actualite.save
        format.html { redirect_to @actualite, notice: "Actualité créée avec succès." }
        format.json { render :show, status: :created, location: @actualite }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @actualite.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @actualite.update(actualite_params)
        format.html { redirect_to @actualite, notice: "Actualité à été mis à jour avec succès !" }
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
      params.require(:actualite).permit(:titre, :contenu, :image, :user_id)
    end
end
