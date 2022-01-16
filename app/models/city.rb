# frozen_string_literal: true

class City < ApplicationRecord
  has_many :tickets_as_source, foreign_key: 'source_city', class_name: 'Ticket',
                               inverse_of: :source_city, dependent: :restrict_with_error
  has_many :user_tickets_as_source, through: :tickets_as_source, source: :user_tickets
  has_many :tickets_as_destination, foreign_key: 'destination_city', class_name: 'Ticket',
                                    inverse_of: :destination_city, dependent: :restrict_with_error
  has_many :user_tickets_as_destination, through: :tickets_as_destination, source: :user_tickets
  has_many :universities, dependent: :restrict_with_error

  validates :id, presence: true, uniqueness: true
  validates :name, presence: true

  def state
    'Rio Grande do Sul'
  end

  def state_abbreviation
    'RS'
  end

  def tickets
    {
      source: tickets_as_source,
      destination: tickets_as_destination
    }
  end

  def user_tickets
    {
      source: user_tickets_as_source,
      destination: user_tickets_as_destination
    }
  end

  # Quantity of students which belongs to the
  def students_count
    User.where(university: universities).count
  end

  # Return all cities which have a user studying in it
  def self.with_users
    User.all_cities
  end

  # Return all cities which have a UserTicket from or to it
  def self.with_tickets
    tickets = Ticket.all
                    .joins(:user_tickets)
                    .group(:id)
                    .joins(:source_city)
                    .joins(:destination_city)
                    .flat_map { |t| [t.source_city, t.destination_city] }

    tickets.uniq
  end

  # Returns an array containing only the name and the id of the City
  # to be used in selects generated on views
  def self.view_select
    pluck(:name, :id)
  end
end
