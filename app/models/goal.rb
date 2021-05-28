class Goal < ApplicationRecord

	belongs_to :user
	has_many :documents, dependent: :destroy
	belongs_to :stage

	validates :category, {presence: true, length: {maximum: 10}}
	validates :goal_status, {presence: true, length: {maximum: 100}}
	validates :deadline, presence: true

end
