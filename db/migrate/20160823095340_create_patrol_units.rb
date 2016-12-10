class CreatePatrolUnits < ActiveRecord::Migration
  def change
    create_table :patrol_units do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
