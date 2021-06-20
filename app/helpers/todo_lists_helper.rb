module TodoListsHelper
  def near_deadline_list_count
    tomorrow = Date.tomorrow
    after_3_days = tomorrow + 2
    current_user.todo_lists.where(:deadline => tomorrow..after_3_days).count
  end

  def today_deadline_list_count
    current_user.todo_lists.where(deadline: Date.today.all_day).count
  end

  def over_deadline_list_count
    current_user.todo_lists.where("deadline < ?", Date.yesterday).count
  end
end
