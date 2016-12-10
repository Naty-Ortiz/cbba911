class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :typename

      t.timestamps null: false
    end
  end
end
