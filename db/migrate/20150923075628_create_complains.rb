class CreateComplains < ActiveRecord::Migration
  def change
    create_table :complains do |t|
    
      t.text :description
      t.string :protagonists
      t.string :zone
      t.float :latitude
      t.float :longitude
      t.references :crime, index: true, foreign_key: true
      t.references :contravertion, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
