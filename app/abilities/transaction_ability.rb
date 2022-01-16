# frozen_string_literal: true

class TransactionAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, Transaction if user.admin?

    # Treasurer can do anything with the transactions, but open already closed one
    can :manage, Transaction if user.treasurer?
    cannot :open, Transaction, status: :close if user.treasurer?

    # President can see all transactions
    can :read, Transaction if user.president?

    # Can read own transactions
    can :read, Transaction, user_id: user.id
  end
end
