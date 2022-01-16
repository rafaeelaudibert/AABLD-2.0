# frozen_string_literal: true

class UserTicketAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, UserTicket if user.admin?
    can :manage, UserTicket if user.treasurer?
  end
end
