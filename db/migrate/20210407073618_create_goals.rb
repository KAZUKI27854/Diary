class CreateGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :goals do |t|
      t.text :goal_status
      t.datetime :deadline
      t.text :category
      t.integer :category_level
      t.text :milestone
      t.integer :user_id

      t.timestamps
    end
  end
end
