# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  layout 'basic'

  # Overrides to check CanCan authorization
  def new
    authorize! :new, User
    super
  end

  def create
    authorize! :create, User
    super
  end

  def update
    super
  end

  def edit
    super
  end

  def after_accept_path_for(_resource)
    dashboard_path
  end

  def after_invite_path_for(_resource)
    new_user_invitation_path
  end

  private

  # Configure Strong params
  def invite_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :cpf, :rg, :birthdate,
      :phone, :mobile_phone, :address, :mother_name, :father_name,
      :bank_account, :bank_agency, :bank_option, :university_id,
      :place, :course, :responsible_id, :semester, :about,
      :ticket_responsible, :semester_start, :semester_end
    )
  end

  # Configure CanCan Ability
  def current_ability
    @current_abiliy = UserAbility.new(current_user)
  end
end
