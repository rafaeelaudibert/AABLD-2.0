# frozen_string_literal: true

class UserTicket < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  belongs_to :monthly_transaction, class_name: 'Transaction',
                                   foreign_key: 'transaction_id',
                                   inverse_of: :user_tickets

  validates :quantity, presence: true,
                       numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  delegate :source_city, :destination_city, :bus_company, :value, to: :ticket, allow_nil: true

  def total
    quantity * original_value
  end

  def transfered_total
    (total * Ticket::TRANSFER_RATE).round 2
  end
end
