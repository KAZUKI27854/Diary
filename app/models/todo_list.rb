class TodoList < ApplicationRecord

  belongs_to :goal

  validates :body, {presence: true, length: {maximum: 100}}
	validates :deadline, presence: true

end
