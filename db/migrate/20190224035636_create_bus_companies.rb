# frozen_string_literal: true

class CreateBusCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :bus_companies do |t|
      t.string :name, null: false
      t.string :cnpj, null: false, index: true, limit: 18
      t.string :city, default: 'Não se aplica'
      t.string :neighborhood, default: 'Não se aplica'
      t.string :address, default: 'Não se aplica'
    end
  end
end
