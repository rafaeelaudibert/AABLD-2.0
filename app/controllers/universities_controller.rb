# frozen_string_literal: true

class UniversitiesController < ApplicationController
  # CanCan authorization and loading
  load_and_authorize_resource

  # Breadcrumbs configuration
  breadcrumb 'Universidades', :universities_path
  breadcrumb -> { @university.abbreviation },
             -> { university_path(@university) },
             only: %i[show edit]
  breadcrumb 'Criar', :new_university_path, only: :new
  breadcrumb 'Editar', :edit_university_path, only: :edit

  # GET /universities
  # GET /universities.json
  def index
    @pagy, @universities = pagy University.accessible_by(current_ability)
  end

  # GET /universities/:id
  # GET /universities/:id.json
  def show; end

  # GET /universities/new
  def new; end

  # GET /universities/:id/edit
  def edit; end

  # POST /universities
  # POST /universities.json
  def create
    respond_to do |format|
      if @university.save
        format.html { redirect_to @university, notice: 'Universidade criada com sucesso.' }
        format.json { render :show, status: :created, location: @university }
      else
        format.html { render :new }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /universities/:id
  # PATCH/PUT /universities/:id.json
  def update
    respond_to do |format|
      if @university.update(university_params)
        format.html { redirect_to @university, notice: 'Universidade atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @university }
      else
        format.html { render :edit }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /universities/:id
  # DELETE /universities/:id.json
  def destroy
    @university.destroy!
    respond_to do |format|
      format.html { redirect_to universities_url, notice: 'Universidade excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def university_params
    params.require(:university).permit(
      :name, :abbreviation, :cnpj, :city_id, :neighborhood, :address
    )
  end

  # Configure the ability for CanCan
  def current_ability
    @current_ability ||= UniversityAbility.new(current_user)
                                          .merge(SidebarAbility.new(current_user))
  end
end
