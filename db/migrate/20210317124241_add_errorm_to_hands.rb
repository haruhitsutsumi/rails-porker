class AddErrormToHands < ActiveRecord::Migration[5.0]
  def change
    add_column :hands, :error_message, :string
  end
end
