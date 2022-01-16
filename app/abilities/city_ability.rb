# frozen_string_literal: true

class CityAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, City if user.admin?
    can :read, City
  end
end
