class RemoveSkill3FromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :skill3, :text
  end
end
