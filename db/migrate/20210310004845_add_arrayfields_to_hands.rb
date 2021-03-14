class AddArrayfieldsToHands < ActiveRecord::Migration[5.0]
  def change
    add_column :hands, :array1, :string
    add_column :hands, :array2, :string
    add_column :hands, :array3, :string
    add_column :hands, :array4, :string
    add_column :hands, :array5, :string
  end
end
