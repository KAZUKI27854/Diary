module UsersHelper
  def floor
    Goal.where(id: document.goal_id).size
  end
end
