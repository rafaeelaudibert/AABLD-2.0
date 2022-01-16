# frozen_string_literal: true

class UniversityAbility
  include CanCan::Ability

  def initialize(user)
    can :manage, University if user.admin?
    can :manage, University if user.president?
    can :read, University
  end
end
