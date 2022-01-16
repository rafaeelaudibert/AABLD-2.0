# frozen_string_literal: true

class BusCompany < ApplicationRecord
  has_many :tickets, dependent: :restrict_with_error
  has_many :user_tickets, through: :tickets

  validates :name, presence: true
  validates_cnpj_format_of :cnpj, options: { allow_blank: true, allow_nil: true }

  # Returns an array containing only the name and the id of the BusCompany
  # to be used in selects generated on views
  def self.view_select
    pluck(:name, :id)
  end
end
