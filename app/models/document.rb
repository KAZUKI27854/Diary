class Document < ApplicationRecord
	belongs_to :user
	belongs_to :goal

	attachment :diary_image
end
