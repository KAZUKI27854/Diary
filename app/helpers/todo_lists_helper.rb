module TodoListsHelper
  def lists_with_deadline
    current_user.todo_lists.where(priority: 0)
  end

  def near_deadline_list_count
    tomorrow = Date.tomorrow
    after_3_days = tomorrow + 2
    lists_with_deadline.where(:deadline => tomorrow..after_3_days).count
  end

  def today_deadline_list_count
    lists_with_deadline.where(deadline: Date.today.all_day).count
  end

  def over_deadline_list_count
    lists_with_deadline.where("deadline < ?", Date.yesterday).count
  end
end
