module DocumentsHelper
  # ドキュメント作成時に、関連する目標データを更新
  def when_doc_create_goal_auto_update(goal_id)
    goal = Goal.find(goal_id)
    goal.level += params[:document][:add_level].to_i
    goal.doc_count += 1
    goal.stage_id = (goal.doc_count + 4) / 5
    goal.update_attributes(level: goal.level, doc_count: goal.doc_count, stage_id: goal.stage_id)
  end

  # ドキュメント更新時に目標を変更する場合、変更前の目標データを元に戻す
  def when_doc_change_goal_origin_goal_auto_update
    origin_goal_id = params[:document][:origin_goal_id].to_i
    goal = Goal.find(origin_goal_id)
    goal.level -= params[:document][:origin_add_level].to_i
    goal.doc_count -= 1
    if goal.doc_count == 0
      goal.stage_id = 1
    else
      goal.stage_id = (goal.doc_count + 4) / 5
    end
    goal.update_attributes(level: goal.level, doc_count: goal.doc_count, stage_id: goal.stage_id)
  end

  # ドキュメント削除時に、関連する目標データを更新
  def when_doc_destroy_goal_auto_update(document_id)
    document = Document.find(document_id)
    goal = document.goal
    goal.level -= document.add_level
    goal.doc_count -= 1
    if goal.doc_count == 0
      goal.stage_id = 1
    else
      goal.stage_id = (goal.doc_count + 4) / 5
    end
    goal.update_attributes(level: goal.level, doc_count: goal.doc_count, stage_id: goal.stage_id)
  end

  # 同一目標に関して、何番目に投稿されたドキュメントか
  def doc_number(document_id)
    document = Document.find_by(id: document_id)
    documents = Document.where(goal_id: document.goal_id)
    id_index = documents.pluck(:id)
    id_index.index(document_id) + 1
  end

  def within_100_and_not_multiples_of_5?(document_id)
    number = doc_number(document_id)
    number <= 100 && (number % 5) != 0
  end

  def within_100_and_multiples_of_5?(document_id)
    number = doc_number(document_id)
    number <= 100 && (number % 5) == 0
  end

  def timelimit(document_id)
    document = Document.find_by(id: document_id)
    (document.goal.deadline.to_date - document.created_at.to_date).to_i
  end
end
