class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.string "user_id"
      t.string "browser"
      t.string "ip_address"
      t.string "controller"
      t.string "action"
      t.string "params"
      t.string "note"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.timestamps null: false
    end
  end
end
