# frozen_string_literal: true

class WelcomeController < ApplicationController
  layout false
  skip_before_action :authenticate_user!

  def index
    @has_direction = User.on_direction.count.positive?

    return unless @has_direction

    @president = User.president.limit(1).first
    @treasurer = User.treasurer.limit(1).first
    @secretary = User.secretary.limit(1).first
  end
end
