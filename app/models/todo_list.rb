class TodoList < ApplicationRecord
  scope :classify, -> { order(:priority, :deadline) }

  belongs_to :goal
  belongs_to :user

  validates :body, {presence: true, length: {maximum: 100}}
  validate :day_after_today

	def day_after_today
	  unless deadline == nil
	    errors.add(:deadline, 'は、本日以降の日付を入力して下さい') if deadline.to_date < Date.today
	  end
	end
end