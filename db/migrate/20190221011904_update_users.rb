# frozen_string_literal: true

class UpdateUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false, default: ''
      t.string :cpf, index: true, limit: 14   # Non-nullity defined on model
      t.string :rg, index: true, limit: 15    # Non-nullity defined on model
      t.date :birthdate                       # Non-nullity defined on model
      t.string :father_name, default: 'Não consta'
      t.string :mother_name                   # Non-nullity defined on model
      t.string :address, default: ''          # Non-nullity defined on model
      t.string :phone, default: 'Não consta'  # Non-nullity defined on model
      t.string :mobile_phone, default: 'Não consta' # Non-nullity defined on model
      t.string :bank_account                  # Non-nullity defined on model
      t.string :bank_agency                   # Non-nullity defined on model
      t.integer :bank_option                  # Non-nullity defined on model
      t.references :university, index: true
      t.string :course                        # Non-nullity defined on model
      t.integer :semester                     # Non-nullity defined on model
      t.string :place                         # Non-nullity defined on model
      t.date :semester_start                  # Non-nullity defined on model
      t.date :semester_end                    # Non-nullity defined on model
      t.string :about, default: ''
      t.integer :responsible_id, index: true
      t.boolean :ticket_responsible, index: true, null: false, default: false
      t.integer :role, index: true, default: 0 # Non-nullity defined on model
    end

    add_foreign_key :users, :users, column: :responsible_id
  end
end
