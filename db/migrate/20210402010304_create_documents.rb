class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.text :title
      t.text :body
      t.string :diary_image_id
      t.integer :user_id

      t.timestamps
    end
  end
end
