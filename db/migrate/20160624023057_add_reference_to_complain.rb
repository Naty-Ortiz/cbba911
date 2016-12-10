class AddReferenceToComplain < ActiveRecord::Migration
  def change
    create_table :complainants do |t|
      t.string :name
      t.string :last_name
      t.integer :ci
      t.integer :phone
      t.references :complain, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
