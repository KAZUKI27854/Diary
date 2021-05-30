class Goal < ApplicationRecord

	belongs_to :user
	belongs_to :stage
	has_many :documents, dependent: :destroy
	has_many :todo_lists, dependent: :destroy

	validates :category, {presence: true, length: {maximum: 10}}
	validates :goal_status, {presence: true, length: {maximum: 100}}
	validates :deadline, presence: true

end
