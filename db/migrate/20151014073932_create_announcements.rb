class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :content
      t.boolean :accepted
      t.boolean :global
      t.references :employee, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
