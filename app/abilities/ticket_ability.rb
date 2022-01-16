# frozen_string_literal: true

class TicketAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, Ticket if user.admin?
    can :manage, Ticket if user.president? || user.treasurer?
    can :read, Ticket
  end
end
