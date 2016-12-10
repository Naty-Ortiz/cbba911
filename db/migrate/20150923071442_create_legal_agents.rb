class CreateLegalAgents < ActiveRecord::Migration
  def change
    create_table :legal_agents do |t|
      t.integer :identification_number
      t.integer :identification_type
      t.string :first_name
      t.string :string
      t.string :last_name
      t.string :country
      t.string :city
      t.string :address
      t.string :phone_number
      t.string :email
      t.string :mailbox
      t.references :user, index: true, foreign_key: true
      t.references :crime, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
