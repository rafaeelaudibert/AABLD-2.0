# frozen_string_literal: true

class AddDefaultToUsersField < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :place, :string, default: 'Não consta'
  end
end
