module UsersHelper

  def clear_count(user_id)
    document = Document.where(user_id: user_id)
    documents = document.group(:goal_id).sum(:add_level)
    documents.values.count{ |level| level >= 100 }
  end

  def timelimit(id, document)
	 ((Goal.find_by(id: id).deadline - document.updated_at)/86400).to_i
  end
end
