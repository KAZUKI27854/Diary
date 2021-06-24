module TodoListsHelper
  def lists_with_deadline
    current_user.todo_lists.where(priority: 0)
  end

  def near_deadline_list_count
    today = Date.current
    after_3_days = today + 3
    lists_with_deadline.where(:deadline => today..after_3_days).count
  end

  def today_deadline_list_count
    lists_with_deadline.where(deadline: Date.current.all_day).count
  end

  def over_deadline_list_count
    yesterday = Date.current - 1
    lists_with_deadline.where("deadline < ?", yesterday).count
  end
end
