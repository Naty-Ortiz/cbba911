class AddPhoneToPerson < ActiveRecord::Migration
  def change
    add_column :people, :phone_number, :string
  end
end
