class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_alteration, :boolean, :default => false
  end
end
