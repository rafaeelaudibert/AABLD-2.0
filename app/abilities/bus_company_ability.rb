# frozen_string_literal: true

class BusCompanyAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, BusCompany if user.admin?
    can :manage, BusCompany if user.president?
    can :read, BusCompany
  end
end
