module UsersHelper

  def cat_level(goal_id)
    Document.where(goal_id: goal_id).sum(:add_level)
  end

  def cat_name(id)
	  Goal.find_by(id: id).category
  end

  def clear_count(user_id)
    document = Document.where(user_id: user_id)
    documents = document.group(:goal_id).sum(:add_level)
    documents.values.count{ |level| level >= 100 }
  end

  def doc_count(goal_id)
    Document.where(goal_id: goal_id).count
  end

  def doc_number(goal_id, document_id)
	  documents = Document.where(goal_id: goal_id)
	  id_index = documents.pluck(:id)
	  id_index.index(document_id) + 1
  end

  def stage_name(goal_id)
    stage_number = (doc_count(goal_id) / 5) + 1
    Stage.find_by(id: stage_number).name
  end

  def timelimit(id, document)
	 ((Goal.find_by(id: id).deadline - document.updated_at)/86400).to_i
  end
end
