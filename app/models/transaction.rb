# frozen_string_literal: true

class Transaction < ApplicationRecord
  include EnumI18nHelper

  belongs_to :user
  has_many :user_tickets, dependent: :restrict_with_error
  has_many :tickets, through: :user_tickets

  validates :month, presence: true
  validates :year, presence: true,
                   numericality: { only_integer: true, greater_than_or_equal_to: 2019 }
  validate :not_duplicated

  MONTH_LIST = %w[january february march april may june
                  july august september october november december].each(&:freeze)

  enum month: MONTH_LIST.each_with_index.to_h { |month, idx| [month, idx + 1] }
  enum status: { open: 0, finish: 1, close: 2 }

  # Scopes
  scope :from_current_month, -> { where(month: current_month_index, year: current_year) }

  # Returns a beautified string for the Transaction breadcrumb
  def breadcrumb
    "Transação de #{beautified_date}"
  end

  # Returns the year and month of the transaction
  def beautified_date
    "#{enum_t(self, :month)}-#{year}"
  end

  # Returns a string containing the type of badge, according to the Transaction status
  def badge_for_status
    case status.to_sym
    when :open
      'warning'
    when :finish
      'primary'
    when :close
      'success'
    end
  end

  # Computes the total value in the transaction
  def value
    user_tickets.sum(&:total)
  end

  # Computes the total transfered value in the transaction
  def transfered_value
    user_tickets.sum(&:transfered_total)
  end

  # All transactions from a given user
  def self.from_user(user)
    where(user: user)
  end

  # Returns the index of the month we are currently creating Transaction instances
  def self.current_month_index
    ((Time.zone.now.utc.to_date.month - 2) % 12) + 1
  end

  # Returns the year that we are currently creating Transaction instances
  def self.current_year
    current_month_index == 12 ? Time.zone.now.utc.to_date.year - 1 : Time.zone.now.utc.to_date.year
  end

  private

  def not_duplicated
    same_transactions = Transaction.where(user: user, month: month, year: year)
    return if same_transactions.count.zero? || same_transactions.first == self

    errors.add(:user, 'já possui uma transação nesse mês e ano')
  end
end
