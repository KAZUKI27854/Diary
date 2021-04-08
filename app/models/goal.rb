class Goal < ApplicationRecord
  MAX_GOALS_COUNT = 3

	belongs_to :user
	has_many :documents, dependent: :destroy

	validate :goals_count_must_be_within_limit, on: :create
	validates :category, {presence: true, length: {maximum: 20}}
	validates :goal_status, {presence: true, length: {maximum: 100}}
	validates :deadline, presence: true

	  def goals_count_must_be_within_limit
	    if user.goals.count > MAX_GOALS_COUNT
	      errors[:base] << "もくひょうは３つまでせっていできます"
	    end
	  end

end
