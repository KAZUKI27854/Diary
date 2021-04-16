module UsersHelper

  def cat_level(goal_id)
    Document.where(goal_id: goal_id).sum(:add_level)
  end

	def cat_name(id)
	  Goal.find_by(id: id).category
	end

	def doc_count_by_cat(goal_id, document_id)
		documents = Document.where(goal_id: goal_id)
		id_index = documents.pluck(:id)
		id_index.index(document_id) + 1
	end

	def timelimit(id, document)
	  ((Goal.find_by(id: id).deadline - document.updated_at)/86400).to_i
	end
end
