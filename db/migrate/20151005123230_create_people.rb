class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.integer :identification_number
      t.integer :identification_type
      t.string :firs_name
      t.string :last_name
      t.string :country
      t.string :city
      t.string :address
      t.string :email
      t.string :profession
      t.string :position
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
