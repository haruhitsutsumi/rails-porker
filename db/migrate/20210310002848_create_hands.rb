class CreateHands < ActiveRecord::Migration[5.0]
  def change
    create_table :hands do |t|
      t.string :flashj
      t.string :pairj
      t.string :straightj
      t.string :fainalj

      t.timestamps
    end
  end
end
