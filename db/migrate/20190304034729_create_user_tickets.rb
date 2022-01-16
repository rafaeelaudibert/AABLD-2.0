# frozen_string_literal: true

class CreateUserTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :user_tickets, id: false do |t|
      t.uuid :id, null: false, default: 'uuid_generate_v4()', primary_key: true
      t.references :user, foreign_key: true
      t.references :ticket, foreign_key: true, type: :uuid
      t.references :transaction, foreign_key: true, type: :uuid
      t.integer :quantity, null: false, default: 1
      t.decimal :original_value, precision: 5, scale: 2, null: false

      t.timestamps
    end
  end
end
