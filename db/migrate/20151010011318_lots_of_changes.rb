class LotsOfChanges < ActiveRecord::Migration
  def change

      #peolpe
      remove_column :people, :position
      remove_column :people, :profession
      rename_column :people, :firs_name, :first_name
      change_column :people, :identification_number, :string



      create_table :employee do |t|
        t.string :position
        t.string :profession
        t.string :agent_id
        t.references :person, index: true, foreign_key: true
        t.timestamps null: false
      end
  end
end
