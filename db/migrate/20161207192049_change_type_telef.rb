class ChangeTypeTelef < ActiveRecord::Migration

	def self.up
		change_column :complains, :telephoneNumberComplainantFromMigrateData, :integer
	end
    def self.down
    	change_column :complains, :telephoneNumberComplainantFromMigrateData, :string
    end
end
