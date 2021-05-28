class AddColumnsToGoals < ActiveRecord::Migration[5.2]
  def change
    add_column :goals, :level, :integer, default: 0
    add_column :goals, :stage_id, :integer
    add_column :goals, :doc_count, :integer, default: 0
  end
end
