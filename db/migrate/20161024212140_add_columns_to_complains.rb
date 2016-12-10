class AddColumnsToComplains < ActiveRecord::Migration
  def change
	add_column :complains, :operatorNameFromMigrateData, :string
	add_column :complains, :telephoneNumberComplainantFromMigrateData, :integer
	add_column :complains, :complainantNameFromMigrateData, :string
  	add_column :complains, :addressFromMigrateData, :string

  end
end
