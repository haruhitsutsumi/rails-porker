class ChangeColumnType < ActiveRecord::Migration[5.0]
  def change
    change_column :hands, :flashj, :boolean
    change_column :hands, :straightj, :boolean
    rename_column :hands, :fainalj, :finalj
    
  end
end
