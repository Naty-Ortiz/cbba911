class LotsOfChange < ActiveRecord::Migration
  def change
    #legal_agent

    remove_column :crimes, :address
    remove_column :contravertions, :description
    add_column :contravertions, :code , :integer

    add_reference :complains, :user, index: true, foreign_key: true
  end
end
