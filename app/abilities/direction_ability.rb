# frozen_string_literal: true

class DirectionAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, :direction if user.admin? || user.president?
    can :read, :direction
  end
end
