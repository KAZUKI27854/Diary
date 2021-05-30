class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.integer :user_id, null: false
      t.integer :stage_id, default: 1, null: false
      t.string :category, null: false
      t.string :goal_status, null: false
      t.datetime :deadline, null: false
      t.integer :level, default: 0, null: false
      t.integer :doc_count, default: 0, null: false

      t.timestamps
    end
  end
end
