class AddAndRemoveColumns < ActiveRecord::Migration
  def change
    remove_column :crimes, :code
    remove_column :contravertions, :code
    add_column :contravertions, :code , :string
    add_column :crimes, :code , :string
  end
end
