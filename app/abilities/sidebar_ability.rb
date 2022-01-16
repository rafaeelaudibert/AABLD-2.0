# frozen_string_literal: true

class SidebarAbility
  include CanCan::Ability

  def initialize(user)
    # Admin can manage anything
    can :manage, :all if user.admin?

    # Everybody can access Dashboard panel
    can :access, :dashboard

    # Configure General tab
    can_general user

    # Configure Administrative panel
    can_administrative user
  end

  private

  def can_general(_user)
    # Everybody can access Transactions panel
    can :access, :transactions

    # Everybody can access Direction panel
    can :access, :direction

    # Everybody can access Users panel
    can :access, :users
  end

  def can_administrative(_user)
    # Everybody can access Tickets panel
    can :access, :tickets

    # Everybody can access BusCompanies panel
    can :access, :bus_companies

    # Everybody can access Cities panel
    can :access, :cities

    # Everybody can access Universities panel
    can :access, :universities
  end
end
