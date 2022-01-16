# frozen_string_literal: true

class UsersController < ApplicationController
  # CanCan authorization
  load_and_authorize_resource

  # Configure before_action
  before_action :set_user, only: :reinvite

  # Breadcrumb configuration
  breadcrumb -> { @user.full_name },
             -> { @user },
             except: :index
  breadcrumb 'Edição', only: :show

  def index
    @pagy, @users = pagy User.where.not(role: :admin).search(params[:search])
  end

  def show; end

  def edit; end

  # POST /user/:id/edit
  def update
    if current_user.admin? || current_user.on_direction? # Is admin or on direction, and doesn't need password
      update_without_password
    elsif current_user == @user # Need to use the password to update their data
      update_with_password
    end
  end

  # POST :id/reinvite
  def reinvite
    if @user.invitation_accepted?
      redirect_back fallback_location: dashboard_path,
                    alert: 'Usuário já confirmou seu convite'
    else
      @user.invite!
      redirect_back fallback_location: dashboard_path,
                    notice: 'Convite reenviado com sucesso'
    end
  end

  private

  # Set user
  def set_user
    @user = User.find(params[:user_id])
  end

  def update_without_password
    respond_to do |format|
      if @user.update(admin_user_params)
        format.html { redirect_to @user, notice: 'Usuário atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def admin_user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :cpf, :rg, :birthdate,
      :phone, :mobile_phone, :address, :mother_name, :father_name,
      :bank_account, :bank_agency, :bank_option,
      :university_id, :place, :course, :responsible_id, :semester,
      :about, :ticket_responsible, :semester_start, :semester_end
    )
  end

  def update_with_password
    respond_to do |format|
      if @user.update_with_password(with_password_user_params)
        bypass_sign_in(@user)
        format.html { redirect_to @user, notice: 'Usuário atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def with_password_user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :cpf, :rg, :birthdate,
      :phone, :mobile_phone, :address, :mother_name, :father_name,
      :about, :password, :password_confirmation, :current_password,
      :semester_start, :semester_end
    )
  end

  def current_ability
    @current_ability ||= UserAbility.new(current_user)
                                    .merge(SidebarAbility.new(current_user))
  end
end
