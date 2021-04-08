class AddDetailsToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :milestone, :text
    add_column :documents, :add_level, :integer
    add_column :documents, :goal_id, :integer
  end
end
