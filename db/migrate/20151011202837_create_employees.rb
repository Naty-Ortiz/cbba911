class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :position
      t.string :profession
      t.string :agent_id
      t.references :person, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
