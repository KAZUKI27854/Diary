module GoalsHelper
  def latest_milestone(goal_id)
    documents = Document.where(goal_id: goal_id).order(updated_at: :desc)
    documents.first.milestone
  end

  def near_deadline_goal_count
    tomorrow = Date.tomorrow
    after_3_days = tomorrow + 2
    current_user.goals.where(:deadline => tomorrow..after_3_days).count
  end

  def today_deadline_goal_count
    current_user.goals.where(deadline: Date.today.all_day).count
  end

  def over_deadline_goal_count
    current_user.goals.where("deadline < ?", Date.yesterday).count
  end
end
