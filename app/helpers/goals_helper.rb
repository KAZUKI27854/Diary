module GoalsHelper
  def latest_milestone(goal_id)
    documents = Document.where(goal_id: goal_id).order(updated_at: :desc)
    documents.first.milestone
  end

  def goals_not_cleared
    current_user.goals.where("level < ?", 100)
  end

  def near_deadline_goal_count
    tomorrow = Date.tomorrow
    after_3_days = tomorrow + 2
    goals_not_cleared.where(:deadline => tomorrow..after_3_days).count
  end

  def today_deadline_goal_count
    goals_not_cleared.where(deadline: Date.today.all_day).count
  end

  def over_deadline_goal_count
    goals_not_cleared.where("deadline < ?", Date.yesterday).count
  end
end
