module TodoListsHelper
  def not_finished_lists
    current_user.todo_lists.where.not(priority: 2)
  end

  def near_deadline_list_count
    tomorrow = Date.tomorrow
    after_3_days = tomorrow + 2
    not_finished_lists.where(:deadline => tomorrow..after_3_days).count
  end

  def today_deadline_list_count
    not_finished_lists.where(deadline: Date.today.all_day).count
  end

  def over_deadline_list_count
    not_finished_lists.where("deadline < ?", Date.yesterday).count
  end
end
