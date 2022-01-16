# frozen_string_literal: true

class TicketsController < ApplicationController
  # CanCan authorization and loading
  load_and_authorize_resource

  # Breadcrumbs configuration
  breadcrumb 'Passagens', :tickets_path
  breadcrumb -> { @ticket.itinerary }, -> { ticket_path(@ticket) }, only: %i[show edit]
  breadcrumb 'Criar', :new_ticket_path, only: :new
  breadcrumb 'Editar', :edit_ticket_path, only: :edit

  # GET /tickets
  # GET /tickets.json
  def index
    @pagy, @tickets = pagy Ticket.accessible_by(current_ability)
  end

  # GET /tickets/:id
  # GET /tickets/:id.json
  def show; end

  # GET /tickets/new
  def new; end

  # GET /tickets/:id/edit
  def edit; end

  # POST /tickets
  # POST /tickets.json
  def create
    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Passagem criada com sucesso.' }
        format.json { render :show, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/:id
  # PATCH/PUT /tickets/:id.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Passagem atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/:id
  # DELETE /tickets/:id.json
  def destroy
    @ticket.destroy!
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Passagem excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def ticket_params
    params.require(:ticket).permit(:source_city_id, :destination_city_id, :value, :bus_company_id)
  end

  # Configure the ability for CanCan
  def current_ability
    @current_ability ||= TicketAbility.new(current_user)
                                      .merge(SidebarAbility.new(current_user))
  end
end
