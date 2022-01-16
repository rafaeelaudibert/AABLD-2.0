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

def seed_bus_companies # rubocop:disable Metrics/MethodLength
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
end

# Call the main method
main
