class Document < ApplicationRecord
	belongs_to :user
	belongs_to :goal

	validates :body, {presence: true, length: {maximum: 100}}
	validates :milestone, {presence: true, length: {maximum: 100}}
	validates :add_level, presence: true

	attachment :document_image

end
