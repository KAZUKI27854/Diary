class CreateTodoLists < ActiveRecord::Migration[5.2]
  def change
    create_table :todo_lists do |t|
      t.integer :user_id, null: false
      t.integer :goal_id, null: false
      t.string :body, null: false
      t.datetime :deadline
      t.boolean :is_finished, default: false, null: false
      t.integer :priority, default: 0, null: false

      t.timestamps
    end
  end
end
