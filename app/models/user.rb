# frozen_string_literal: true

require 'letter_avatar/has_avatar'

class User < ApplicationRecord
  include LetterAvatar::HasAvatar
  include EnumI18nHelper

  # Include default devise modules. Others available are:
  # :lockable, :confirmable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :timeoutable, :async

  has_many :transactions, -> { order(:created_at) },
           dependent: :restrict_with_error,
           inverse_of: :user
  has_many :user_tickets, -> { order(:created_at) },
           dependent: :restrict_with_error,
           inverse_of: :user
  belongs_to :responsible, optional: true, class_name: 'User'
  belongs_to :university
  has_one :city, through: :university

  after_save :validate_responsible

  validates :first_name, presence: true
  validates :rg, presence: true, uniqueness: true
  validates :cpf, presence: true, uniqueness: true
  validates_cpf_format_of :cpf, options: { allow_blank: true, allow_nil: true }
  validates :mother_name, presence: true
  validates :birthdate, presence: true
  validates :bank_account, presence: true
  validates :bank_agency, presence: true
  validates :course, presence: true
  validates :semester, presence: true
  validates :about, length: { maximum: 200 }

  enum bank_option: { checking: 0, savings: 1 }
  enum role: {
    member: 0,
    president: 1,
    vice_president: 2,
    treasurer: 3,
    vice_treasurer: 4,
    secretary: 5,
    vice_secretary: 6,
    fiscal_council: 7,
    admin: 8
  }

  # Constants
  DIRECTION_SIZE = 9 # Direction size, with 3 members in the Fiscal Council

  # Scopes
  scope :not_admin, -> { where.not(role: :admin) }
  scope :on_direction, -> { where.not(role: %i[admin member]).order(:role) }

  # Returns the User instance full name, concatenating <tt>first_name</tt> and <tt>last_name</tt>
  def full_name
    "#{first_name} #{last_name}"
  end
  alias name full_name # Used by LetterAvatar

  # Return a string with the User parent names
  def parents
    "#{mother_name} #{"e #{father_name}" unless father_name.nil?}"
  end

  # Return a string with the User parsed bank information
  def bank_information
    "Ag. #{bank_agency} | Conta: #{bank_account} | #{enum_t(self, :bank_option)}"
  end

  # Returns the user age
  def age
    now = Time.zone.now
    birthdate_time = birthdate.to_time
    ActiveSupport::Duration.build(now - birthdate_time).parts[:years]
  end

  # Returns true if there already exists a Transaction created in this month for the User
  def did_monthly_transaction?
    last_transaction = transactions.last
    last_transaction&.month_before_type_cast == Transaction.current_month_index && last_transaction.year == Transaction.current_year
  end

  # Returns true, if the user is a Ticket Responsible
  def ticket_responsible?
    ticket_responsible == true
  end

  # Returns all the users which didn't made their Montly Transaction
  def self.not_did_monthly_transaction
    not_admin.reject(&:did_monthly_transaction?)
  end

  # Users which are ticket responsibles
  def self.ticket_responsibles
    where(ticket_responsible: true)
  end

  # Update the users in the current direction using the ones passed as parameter
  def self.update_direction(direction)
    raise StandardError, 'Sem membros suficientes na diretoria' if direction.uniq
                                                                            .length < DIRECTION_SIZE

    # Remove roles from older direction
    on_direction.each(&:member!)

    # Add new users to direction, assigning the right role to them
    direction.each { |role, user| user.update! role: role.to_sym }
  end

  # Search the user where the name or first name match any of the query
  def self.search(query)
    return all if query == '' || query.nil?

    where('concat(first_name, last_name, email) ILIKE ?', "%#{query}%")
  end

  # Returns if the user belongs to the association direction
  def on_direction?
    president? || treasurer? || secretary? || vice_president? || vice_treasurer? || vice_secretary?
  end

  # Return all the cities which have users
  # This method uses uniq and compact unchained for performance reasons
  def self.all_cities
    all_cities = all.map(&:city)
    all_cities.uniq!
    all_cities.compact!
    all_cities
  end

  # Returns an array containing only the name and the id of the User
  # to be used in selects generated on views
  def self.view_select
    not_admin.map { |user| [user.full_name, user.id] }
  end

  private

  # Update responsible foreign_key, if not present, to point to himself, as well
  # as mark itself as a ticket_responsible
  def validate_responsible
    update(responsible_id: id, ticket_responsible: true) if responsible_id.nil? # rubocop:disable Rails/SaveBang because we want to ignore it during seed
  end
end
