class CreateAverages < ActiveRecord::Migration
  def change
    create_table :averages do |t|
      t.string :name
      t.float :average

      t.timestamps null: false
    end
  end
end
