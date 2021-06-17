module UsersHelper

  def clear_count(user_id)
    document = Document.where(user_id: user_id)
    documents = document.group(:goal_id).sum(:add_level)
    documents.values.count{ |level| level >= 100 }
  end

  def timelimit(document_id)
    document = Document.find_by(id: document_id)
    (document.goal.deadline.to_date - document.created_at.to_date).to_i
  end
end
