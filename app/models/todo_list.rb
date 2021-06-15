class TodoList < ApplicationRecord
  scope :classify, -> { order(:priority, :deadline) }

  belongs_to :goal
  belongs_to :user

  validates :body, {presence: true, length: {maximum: 100}}
end
