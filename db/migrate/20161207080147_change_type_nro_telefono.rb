class ChangeTypeNroTelefono < ActiveRecord::Migration
	def self.up
		change_column :complains, :telephoneNumberComplainantFromMigrateData, :integer
	end
    def self.down
    	change_column :complains, :telephoneNumberComplainantFromMigrateData, :Bignum
    end
end
