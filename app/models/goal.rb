class Goal < ApplicationRecord
  MAX_GOALS_COUNT = 3

	belongs_to :user

	validate :goals_count_must_be_within_limit, on: :create

	  def goals_count_must_be_within_limit
	    if user.goals.count > MAX_GOALS_COUNT
	      errors[:base] << "もくひょうは３つまでせっていできます"
	    end
	  end

end
