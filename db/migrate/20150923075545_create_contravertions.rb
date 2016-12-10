class CreateContravertions < ActiveRecord::Migration
  def change
    create_table :contravertions do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
