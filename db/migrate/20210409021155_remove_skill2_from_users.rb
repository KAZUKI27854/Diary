class RemoveSkill2FromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :skill2, :text
  end
end
