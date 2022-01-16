# frozen_string_literal: true

class UserTicketsController < ApplicationController
  # CanCan authorization and loading
  load_and_authorize_resource

  # POST /user_tickets.json
  def create
    respond_to do |format|
      # If transaction is not open, cannot create a user_ticket
      if !@user_ticket.monthly_transaction.open?
        format.json do
          render json: { transaction: ['Transação não está aberta'] },
                 status: :unprocessable_entity
        end
      elsif @user_ticket.save
        format.json { render :show, status: :ok, location: @user_ticket }
      else
        format.json { render json: @user_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_tickets/:id.json
  def update
    respond_to do |format|
      if @user_ticket.update(user_ticket_params)
        format.json { render :show, status: :ok, location: @user_ticket }
      else
        format.json { render json: @user_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_tickets/:id.json
  def destroy
    respond_to do |format|
      if @user_ticket.destroy
        format.json { head :no_content }
      else
        format.json { render json: @user_ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_ticket_params
    params.require(:user_ticket).permit(
      :user_id, :ticket_id, :quantity, :original_value, :transaction_id
    )
  end

  # Configure the ability for CanCan
  def current_ability
    @current_ability ||= UserTicketAbility.new(current_user)
                                          .merge(SidebarAbility.new(current_user))
  end
end
