class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :title, null: false, default: ""
      t.string :content, null: false, default: ""
      t.integer :channel, null: false, default: 0

      t.timestamps
    end
  end
end
