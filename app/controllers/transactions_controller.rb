# frozen_string_literal: true

class TransactionsController < ApplicationController
  # CanCan authorization and loading
  load_and_authorize_resource

  # Breadcrumbs configuration
  breadcrumb 'Transações', :transactions_path
  breadcrumb -> { @transaction.user.full_name },
             -> { user_transactions_path(@transaction.user, @transaction) },
             only: :show
  breadcrumb -> { @transaction.breadcrumb },
             -> { transaction_path(@transaction) },
             only: :show

  # GET /transactions
  # GET /transactions.json
  def index
    @pagy, @transactions = pagy(
      Transaction.order(status: :asc, year: :desc, month: :desc)
                 .accessible_by(current_ability)
    )
  end

  # GET transactions/:id
  # GET transactions/:id.json
  def show
    @user = @transaction.user

    if @transaction.open? && can?(:edit, @transaction)
      render :edit, layout: 'application'
    else
      render :show
    end
  end

  # DELETE transactions/:id
  # DELETE transactions/:id.json
  def destroy
    @transaction.destroy!
    respond_to do |format|
      format.html { redirect_to transactions_url, notice: 'Transação excluída com sucesso.' }
      format.json { head :no_content }
    end
  end

  # GET transactions/:id/open
  def open
    @transaction.open!
    redirect_back fallback_location: root_path, notice: 'Transação aberta com sucesso.'
  end

  # GET transactions/:id/finish
  def finish
    if @transaction.open?
      @transaction.finish!

      unless @transaction.user_tickets.length.zero?
        TransactionMailer.finish_transaction(@transaction.id).deliver_later
      end

      if should_go_to_next_transaction?
        redirect_to_next_transaction
      else
        redirect_back fallback_location: root_path, notice: 'Transação finalizada com sucesso.'
      end
    else
      redirect_back fallback_location: root_path,
                    alert: 'Transação não foi finalizada, pois não estava aberta.'
    end
  end

  # GET transactions/:id/close
  def close
    if @transaction.finish?
      @transaction.close!
      unless @transaction.user_tickets.length.zero?
        TransactionMailer.close_transaction(@transaction.id).deliver_later
      end

      if should_go_to_next_transaction?
        redirect_to_next_finished_transaction
      else
        redirect_back fallback_location: root_path,
                      notice: 'Fechamendo de transações concluído com sucesso.'
      end
    else
      redirect_back fallback_location: root_path,
                    alert: 'Transação não foi concluída, pois não estava finalizada.'
    end
  end

  private

  # Configure the ability for CanCan
  def current_ability
    @current_ability ||= TransactionAbility.new(current_user)
                                           .merge(SidebarAbility.new(current_user))
  end

  # Params used in the transaction creation
  def transaction_params
    {
      month: Transaction.current_month_index,
      year: Transaction.current_year,
      user_id: User.order(:university_id, :place, :first_name)
                   .not_did_monthly_transaction
                   .first
                   .id
    }
  end

  # Function which returns if it was asked to go to the next_user
  def should_go_to_next_transaction?
    params[:next_transaction].try(:eql?, 'true')
  end

  # Handle redirection to the next user
  def redirect_to_next_transaction
    if User.not_did_monthly_transaction.count.positive?
      redirect_to Transaction.new(transaction_params).tap(&:save!),
                  notice: 'Transação finalizada com sucesso. <br/> Avançando para próxima transação'
    else
      redirect_to transactions_path, notice: 'Transações mensais finalizadas'
    end
  end

  # Handle redirection to the next transaction which is not finished yet
  def redirect_to_next_finished_transaction
    if Transaction.finish.from_current_month.count.positive?
      redirect_to Transaction.finish
                             .from_current_month
                             .joins(:user)
                             .order('users.first_name', 'users.last_name')
                             .first,
                  notice: 'Transação fechada com sucesso. <br/>' \
                          'Avançando para próxima transação ainda não finalizada'
    else
      redirect_to transactions_path, notice: 'Fechamento das transações mensais finalizadas'
    end
  end
end
