class TodoList < ApplicationRecord
  scope :classify, -> { order(:priority, :deadline) }

  belongs_to :goal
  belongs_to :user

  validates :body, {presence: true, length: {maximum: 100}}
  validate :day_after_today

  #過去の日付登録を防ぐバリデーション（期限超過の場合、チェックを入れることだけできる）
  def day_after_today
    if deadline != nil && is_finished ==false
      errors.add(:deadline, 'は、本日以降の日付を入力して下さい') if deadline.to_date < Date.today
    end
  end
end