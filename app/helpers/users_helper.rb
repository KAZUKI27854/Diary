module UsersHelper

  def cat_level(goal_id)
    Document.where(goal_id: goal_id).sum(:add_level)
  end

	def cat_name(id)
	  Goal.find_by(id: id).category
	end
	
	def doc_post_count(goal_id)
		Document.where(goal_id: goal_id).count
	end

	def timelimit(id, document)
	  ((Goal.find_by(id: id).deadline - document.updated_at)/86400).to_i
	end
end
