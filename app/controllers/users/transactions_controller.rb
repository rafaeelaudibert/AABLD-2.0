# frozen_string_literal: true

class Users::TransactionsController < ApplicationController
  # Configure CanCanCan
  load_and_authorize_resource

  # Configure before_Actions
  before_action :authenticate_user!
  before_action :set_user

  # Configure breadcrumb
  breadcrumb 'Usuário', -> { @user }
  breadcrumb 'Transações', -> { user_transactions_path(@user) }

  # GET /users/:user_id/transactions
  # GET /users/:user_id/transactions.json
  def index
    @pagy, @transactions = pagy(
      Transaction.order(status: :asc, year: :desc, month: :desc)
                .accessible_by(current_ability)
                .from_user(@user)
    )
  end

  # POST /users/:user_id/transactions
  # POST /users/:user_id/transactions.json
  def create
    respond_to do |format|
      @transaction.save!
      format.html { redirect_to @transaction, notice: 'Transação criada com sucesso.' }
      format.json { render :show, status: :created, location: @transaction }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:user_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def transaction_params
    params.permit(:user_id).merge(
      month: Transaction.current_month_index,
      year: Transaction.current_year
    )
  end

  # CanCanCan method
  def current_ability
    @current_ability =
      TransactionAbility.new(current_user)
                        .merge(SidebarAbility.new(current_user))
  end
end
