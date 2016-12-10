class AddObservationsToComplains < ActiveRecord::Migration
  def change
    add_column :complains, :observations, :string
  end
end
