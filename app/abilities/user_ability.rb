# frozen_string_literal: true

class UserAbility
  include CanCan::Ability

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/PerceivedComplexity
  def initialize(user)
    can :manage, User if user&.admin?
    can :manage, User if user&.president? # President can manage anything

    # Can create, read and update users if it is on direction
    can %i[create read update reinvite], User if user&.on_direction?

    # Can index and create transactions if it is a high stake
    can %i[index_transaction create_transaction], User if user&.admin? ||
                                                          user&.president? ||
                                                          user&.treasurer?

    # Can see user documents if it is on direction, is admin or is the proper user
    can :see_documents, User if user&.admin? || user &.on_direction?
    can :see_documents, User, id: user&.id

    # Every user can update itself
    can :update, User, id: user&.id

    # Every user has access to see other User profiles
    can :read, User
  end
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/PerceivedComplexity
end
