class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :skill1, :text
    add_column :users, :skill2, :text
    add_column :users, :skill3, :text
  end
end
