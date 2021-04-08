class RemoveCategoryLevelFromGoals < ActiveRecord::Migration[5.2]
  def change
    remove_column :goals, :category_level, :integer
  end
end
