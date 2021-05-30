module GoalsHelper
  def latest_milestone(goal_id)
    documents = Document.where(goal_id: goal_id).order(updated_at: :desc)
    documents.first.milestone
  end
end
