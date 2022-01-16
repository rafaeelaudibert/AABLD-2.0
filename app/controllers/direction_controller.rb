# frozen_string_literal: true

class DirectionController < ApplicationController
  # Breadcrumbs configuration
  breadcrumb 'Direção', :direction_path
  breadcrumb 'Editar', :edit_direction_path, only: :edit

  # GET /direction
  # GET /direction.json
  def show
    authorize! :index, :direction
    @pagy, @users = pagy User.on_direction
  end

  # GET /direction/edit
  # GET /direction/edit.json
  def edit
    authorize! :edit, :direction
    @users = User.view_select
  end

  # PATCH/PUT /direction/
  # PATCH/PUT /direction/.json
  def update
    authorize! :update, :direction

    respond_to do |format|
      User.update_direction direction_from_params
      format.html { redirect_to direction_path, notice: 'Direção atualizada com sucesso.' }
    rescue StandardError => e
      format.html { redirect_back fallback_location: direction_path, alert: e.message }
    end
  end

  private

  # From the direction_params, get all the users which are intending to enter in the Direction
  def direction_from_params
    direction_params.to_h.map do |role, id|
      [/fiscal_council/.match?(role) ? :fiscal_council : role, User.find(id)]
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def direction_params
    params.require(:direction).permit(
      :president, :vice_president,
      :treasurer, :vice_treasurer,
      :secretary, :vice_secretary,
      :fiscal_council_1, :fiscal_council_2, :fiscal_council_3 # rubocop:disable Naming/VariableNumber
    )
  end

  # Configure the ability for CanCan
  def current_ability
    @current_ability ||= DirectionAbility.new(current_user)
                                         .merge(SidebarAbility.new(current_user))
  end
end
