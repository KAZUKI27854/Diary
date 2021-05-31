class TodoList < ApplicationRecord

  belongs_to :goal
  belongs_to :user

  validates :body, {presence: true, length: {maximum: 100}}
	validates :deadline, presence: true

end
