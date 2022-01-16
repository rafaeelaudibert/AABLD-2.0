# frozen_string_literal: true

##
# This is the mailer used in the Transaction model
class TransactionMailer < ApplicationMailer
  # Email which is sent when a transaction is finished
  def finish_transaction(transaction_id)
    @transaction = Transaction.find(transaction_id)
    @user = @transaction.user

    mail to: @user.email, subject: '[AABLD] - Finalização da Transação'
  end

  # Email which is sent when a transaction is closed
  def close_transaction(transaction_id)
    @transaction = Transaction.find(transaction_id)
    @user = @transaction.user

    mail to: @user.email, subject: '[AABLD] - Repasse da Transação'
  end
end
