class AddAddressToComplainants < ActiveRecord::Migration
  def change
    add_column :complainants, :address, :string
  end
end
