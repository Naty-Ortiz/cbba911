class AddComlumnsToComplains < ActiveRecord::Migration
  def change
    add_column :complains, :caseReport, :boolean
    add_column :complains, :shortReport, :text

    add_reference :complains, :patrol_unit, index: true, foreign_key: true
  end
end
