module UsersHelper
  def clear_count
    goals = current_user.goals
    goals.where("level >= ?", 100).count
  end
end
