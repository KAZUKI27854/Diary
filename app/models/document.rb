class Document < ApplicationRecord
	belongs_to :user

	attachment :diary_image
end
