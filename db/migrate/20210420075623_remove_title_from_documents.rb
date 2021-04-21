class RemoveTitleFromDocuments < ActiveRecord::Migration[5.2]
  def change
    remove_column :documents, :title, :text
  end
end
