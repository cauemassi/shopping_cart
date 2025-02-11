# frozen_string_literal: true

class AddFieldsToCart < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :last_interaction_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :carts, :abandoned, :boolean, default: false, null: false
  end
end
