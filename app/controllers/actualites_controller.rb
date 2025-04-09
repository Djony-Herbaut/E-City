class ActualitesController < ApplicationController
  before_action :set_actualite, only: %i[ show edit update destroy ]

  # GET /actualites or /actualites.json
  def index
    @actualites = Actualite.all
  end

  # GET /actualites/1 or /actualites/1.json
  def show
  end

  # GET /actualites/new
  def new
    @actualite = Actualite.new
  end

  # GET /actualites/1/edit
  def edit
  end

  # POST /actualites or /actualites.json
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

  # PATCH/PUT /actualites/1 or /actualites/1.json
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

  # DELETE /actualites/1 or /actualites/1.json
  def destroy
    @actualite.destroy!

    respond_to do |format|
      format.html { redirect_to actualites_path, status: :see_other, notice: "L'actualité à été supprimer correctement !" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_actualite
      @actualite = Actualite.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def actualite_params
      params.expect(actualite: [ :titre, :contenu, :image, :user_id ])
    end
end
