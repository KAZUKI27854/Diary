class RemoveMilestoneFromGoals < ActiveRecord::Migration[5.2]
  def change
    remove_column :goals, :milestone, :text
  end
end
