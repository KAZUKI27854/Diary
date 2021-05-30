module UsersHelper

  def clear_count(user_id)
    document = Document.where(user_id: user_id)
    documents = document.group(:goal_id).sum(:add_level)
    documents.values.count{ |level| level >= 100 }
  end

  def within_100_and_not_multiples_of_5?(goal_id, document_id)
    number = doc_number(goal_id, document_id)
    number <= 100 && (number % 5) != 0
  end

  def within_100_and_multiples_of_5?(goal_id, document_id)
    number = doc_number(goal_id, document_id)
    number <= 100 && (number % 5) == 0
  end

  def timelimit(id, document)
	 ((Goal.find_by(id: id).deadline - document.updated_at)/86400).to_i
  end
end
