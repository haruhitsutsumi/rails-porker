class AddArrayColumnToHands < ActiveRecord::Migration[5.0]
  def change
    add_column :hands, :cards, :string
  end
end
