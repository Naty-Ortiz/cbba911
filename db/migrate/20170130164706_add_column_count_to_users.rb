class AddColumnCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :numberWrongTries, :integer, :null => false, :default => 0
  end
end
