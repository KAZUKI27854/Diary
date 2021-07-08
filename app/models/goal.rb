class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :stage
  has_many :documents, dependent: :destroy
  has_many :todo_lists, dependent: :destroy

  validates :category, { presence: true, length: { maximum: 20 } }
  validates :goal_status, { presence: true, length: { maximum: 100 } }
  validates :deadline, presence: true
  validate :day_after_today

  def day_after_today
    unless deadline.nil?
      errors.add(:deadline, 'は、本日以降の日付を入力して下さい') if deadline.to_date < Date.current
    end
  end
end
