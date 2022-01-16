# frozen_string_literal: true

class DashboardController < ApplicationController
  layout 'no_card'

  def index; end

  private

  # Configure the ability for CanCan
  def current_ability
    @current_ability ||= SidebarAbility.new(current_user)
  end
end
