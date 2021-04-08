class RenameDiaryImageIdColumnToDocuments < ActiveRecord::Migration[5.2]
  def change
    rename_column :documents, :diary_image_id, :document_image_id
  end
end
