# frozen_string_literal: true

require 'faker'
require 'logger'
require 'csv'
require 'cpf_cnpj'

# Options for logger.level DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
Rails.logger = Logger.new(STDOUT)
Rails.logger.level = Logger::INFO

def seed_cities
  Rails.logger.info('[START]  -- Cities insertion')

  CSV.foreach('./db/cities.csv', headers: true) do |row|
    city = City.new(name: row['NOME'], id: row['COD'])
    if city.save
      Rails.logger.debug("[DEBUG]  -- INSERTED a CITY in the database: #{city.id}")
    else
      Rails.logger.error("[ERROR]  -- ERROR inserting CITY #{city.name}")
      Rails.logger.error(city.errors.full_messages)
      raise
    end
  end

  Rails.logger.info('[FINISH] -- Cities insertion')
end

def seed_universities
  Rails.logger.info('[START]  -- Universities insertion')

  CSV.foreach('./db/universities.csv', headers: true) do |row|
    university = University.new(name: row['NOME'],
                                abbreviation: row['SIGLA'],
                                cnpj: row['CNPJ'],
                                city: City.find_by(name: row['NOME_CIDADE']),
                                neighborhood: row['BAIRRO'],
                                address: row['ENDERECO'])
    if university.save
      Rails.logger.debug("[DEBUG]  -- INSERTED a UNIVERSITY in the database: #{university.id}")
    else
      Rails.logger.error("[ERROR]  -- ERROR inserting UNIVERSITY #{university.name}")
      Rails.logger.error(university.errors.full_messages)
      raise
    end
  end

  Rails.logger.info('[FINISH] -- Universities insertion')
end

def seed_bus_companies
  Rails.logger.info('[START]  -- Bus Companies insertion')

  CSV.foreach('./db/bus_companies.csv', headers: true) do |row|
    bus_company = BusCompany.new(name: row['NOME'],
                                 cnpj: row['CNPJ'],
                                 city: row['CIDADE'],
                                 neighborhood: row['BAIRRO'],
                                 address: row['ENDERECO'])
    if bus_company.save
      Rails.logger.debug("[DEBUG]  -- INSERTED a BUS COMPANY in the database: #{bus_company.id}")
    else
      Rails.logger.error("[ERROR]  -- ERROR inserting BUS COMPANY #{bus_company.name}")
      Rails.logger.error(bus_company.errors.full_messages)
      raise
    end
  end

  Rails.logger.info('[FINISH] -- Bus Companies insertion')
end

def seed_users
  Rails.logger.info('[START]  -- Users insertion')

  20.times do
    user = User.new(first_name: Faker::Name.first_name,
                    last_name: Faker::Name.last_name,
                    email: Faker::Internet.email,
                    password: Faker::Alphanumeric.alpha(16),
                    cpf: CPF.generate,
                    rg: Faker::Number.number(10),
                    birthdate: Faker::Date.birthday(18, 65),
                    father_name: Faker::Name.male_first_name + ' ' + Faker::Name.last_name,
                    mother_name: Faker::Name.female_first_name + ' ' + Faker::Name.last_name,
                    address: Faker::Address.full_address,
                    phone: Faker::PhoneNumber.phone_number,
                    mobile_phone: Faker::PhoneNumber.phone_number,
                    bank_account: Faker::Number.number(6),
                    bank_agency: Faker::Number.number(5),
                    bank_option: User.bank_options.values.sample,
                    university: University.all.sample,
                    course: Faker::Educator.degree,
                    semester: (1...10).to_a.sample,
                    place: Faker::Address.full_address,
                    semester_start: Time.zone.today,
                    semester_end: Faker::Date.forward(30 * 6),
                    about: Faker::Lorem.paragraph,
                    responsible: User.not_admin.sample,
                    ticket_responsible: false,
                    role: :member)

    if user.save
      Rails.logger.debug("[DEBUG]  -- INSERTED the USER #{user.id} to the database")
    else
      Rails.logger.error("[ERROR]  -- ERROR inserting USER #{user.id}")
      Rails.logger.error(user.errors.full_messages)
      raise
    end
  end
  Rails.logger.info('[FINISH] -- Users insertion')
end

def seed_admin
  Rails.logger.info('[START]  -- Admin insertion')

  admin = User.new(first_name: 'Administrator',
                   last_name: '',
                   email: 'admin@aabld.com',
                   password: 'changeme',
                   role: :admin)
  if admin.save(validate: false)
    Rails.logger.debug('[DEBUG]  -- INSERTED the ADMIN to the database')
  else
    Rails.logger.error('[ERROR]  -- ERROR inserting the ADMIN')
    Rails.logger.error(admin.errors.full_messages)
    raise
  end
  Rails.logger.info('[FINISH] -- Admin insertion')
end

def main
  seed_admin
  seed_cities
  seed_universities
  seed_bus_companies
  seed_users
end

# Call the main method
main
