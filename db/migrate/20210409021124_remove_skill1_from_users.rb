class RemoveSkill1FromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :skill1, :text
  end
end
