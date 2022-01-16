# frozen_string_literal: true

class BusCompaniesController < ApplicationController
  # CanCan authorization and loading
  load_and_authorize_resource

  # Breadcrumbs configuration
  breadcrumb 'Empresas', :bus_companies_path
  breadcrumb -> { @bus_company.name },
             -> { bus_company_path(@bus_company) },
             only: %i[show edit]
  breadcrumb 'Criar', :new_bus_company_path, only: :new
  breadcrumb 'Editar', :edit_bus_company_path, only: :edit

  # GET /bus_companies
  # GET /bus_companies.json
  def index
    @pagy, @bus_companies = pagy BusCompany.accessible_by(current_ability)
  end

  # GET /bus_companies/:id
  # GET /bus_companies/:id.json
  def show; end

  # GET /bus_companies/new
  def new; end

  # GET /bus_companies/:id/edit
  def edit; end

  # POST /bus_companies
  # POST /bus_companies.json
  def create
    respond_to do |format|
      if @bus_company.save
        format.html { redirect_to @bus_company, notice: 'Empresa de ônibus criada.' }
        format.json { render :show, status: :created, location: @bus_company }
      else
        format.html { render :new }
        format.json { render json: @bus_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bus_companies/:id
  # PATCH/PUT /bus_companies/:id.json
  def update
    respond_to do |format|
      if @bus_company.update(bus_company_params)
        format.html { redirect_to @bus_company, notice: 'Empresa de ônibus atualizada.' }
        format.json { render :show, status: :ok, location: @bus_company }
      else
        format.html { render :edit }
        format.json { render json: @bus_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bus_companies/:id
  # DELETE /bus_companies/:id.json
  def destroy
    @bus_company.destroy!
    respond_to do |format|
      format.html { redirect_to bus_companies_url, notice: 'Empresa de ônibus excluída.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def bus_company_params
    params.require(:bus_company).permit(:name, :cnpj, :city, :neighborhood, :address)
  end

  # Configure the ability for CanCan
  def current_ability
    @current_ability ||= BusCompanyAbility.new(current_user)
                                          .merge(SidebarAbility.new(current_user))
  end
end
