class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.integer :user_id, null: false
      t.integer :goal_id, null: false
      t.string :document_image_id
      t.text :body, null: false
      t.integer :add_level, null: false
      t.string :milestone, null: false

      t.timestamps
    end
  end
end
