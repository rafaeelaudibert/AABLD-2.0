# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions, id: false do |t|
      t.uuid :id, null: false, default: 'uuid_generate_v4()', primary_key: true
      t.references :user, foreign_key: true
      t.integer :month, null: false, index: true
      t.integer :year, null: false, index: true
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
