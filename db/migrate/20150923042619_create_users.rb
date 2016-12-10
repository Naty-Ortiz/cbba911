class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :role

      t.timestamps null: false
    end
  end
end
